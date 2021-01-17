module Questions
  class MostAccessedQuery
    def self.call(args)
      new(args).query
    end

    def initialize(args)
      @year = args[:year]
      @month = args[:month]
      @week = args[:week]
    end

    attr_reader :year, :month, :week

    def query
      %w[week month year].each do |param|
        value = send(param)
        next unless value

        @query = QuestionAccess.public_send("by_#{param}", *[year, value].uniq)
        break
      end

      @query&.group(:question_id)&.order('sum_times_accessed desc')&.limit(10)&.sum(:times_accessed)
    end
  end
end
