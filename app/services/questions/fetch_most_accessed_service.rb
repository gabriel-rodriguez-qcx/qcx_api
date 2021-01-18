module Questions
  class FetchMostAccessedService
    def self.call(args)
      new(args).perform
    end

    def initialize(args)
      @args = args
    end

    def perform
      Rails.cache.fetch(cache_key(__method__, @args), expires_in: 1.day) do
        questions = Question.find(most_accessed.keys)

        [questions, most_accessed]
      end
    end

    private

    def most_accessed
      @most_accessed ||= Questions::Elastic::MostAccessedQuery.call(@args)
    end

    def cache_key(prefix, args)
      "#{self.class.name}_#{prefix}_#{args.to_json}"
    end
  end
end
