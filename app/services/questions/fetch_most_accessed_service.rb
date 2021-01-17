module Questions
  class FetchMostAccessedService
    def self.call(args)
      new(args).perform
    end

    def initialize(args)
      @most_accessed = Questions::MostAccessedQuery.call(args)
    end

    def perform
      questions = Question.find(@most_accessed.keys)

      [questions, @most_accessed]
    end
  end
end
