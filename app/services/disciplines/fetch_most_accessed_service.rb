module Disciplines
  class FetchMostAccessedService
    def self.call
      new.perform
    end

    def initialize
      @most_accessed = Disciplines::MostAccessedQuery.call
    end

    def perform
      @most_accessed.map do |discipline, times_accessed|
        Discipline.new(name: discipline, times_accessed: times_accessed, id: discipline)
      end
    end
  end
end
