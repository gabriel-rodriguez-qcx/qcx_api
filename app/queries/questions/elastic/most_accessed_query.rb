module Questions
  module Elastic
    class MostAccessedQuery
      def self.call(args)
        new(args).perform
      end

      def initialize(args)
        @year = args[:year]
        @month = args[:month]
        @week = args[:week]
      end

      def perform
        QuestionAccess
          .search(body: query).aggs.deep_symbolize_keys
          .then { |aggs| aggs.dig(:by_question_id, :buckets) }
          .then do |bucket|
          bucket.each_with_object({}) do |h, acc|
            acc[h[:key]] = h[:sum_times_accessed][:value].to_i
          end
        end
      end

      private

      attr_accessor :year, :month, :week

      def gte
        return date_month if month
        return date_week if week

        date_year
      end

      def lte
        return date_month.end_of_month if month
        return date_week.end_of_week if week

        date_year.end_of_year
      end

      def date_year
        @date_year ||= Date.new(year.to_i)
      end

      def date_month
        @date_month ||= Date.new(year.to_i, month.to_i)
      end

      def date_week
        @date_week ||= Date.commercial(year.to_i, week.to_i)
      end

      # rubocop:disable Metrics/MethodLength
      def query
        @query ||= {
          query: {
            bool: {
              filter: [
                range: {
                  date: {
                    gte: gte,
                    lte: lte
                  }
                }
              ]
            }
          },
          aggs: {
            by_question_id: {
              terms: {
                field: :question_id,
                order: { sum_times_accessed: :desc }
              },
              aggs: {
                sum_times_accessed: {
                  sum: {
                    field: :times_accessed
                  }
                }
              }
            }
          }
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
