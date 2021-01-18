module Disciplines
  class FetchMostAccessedService
    def self.call
      new.perform
    end

    def perform
      most_accessed.map do |discipline, times_accessed|
        Discipline.new(name: discipline, times_accessed: times_accessed, id: discipline)
      end
    end

    private

    def most_accessed
      @most_accessed ||=
        Rails.cache.fetch("#{self.class.name}##{__method__}",
                          expires_in: Time.zone.now.at_end_of_day - Time.zone.now) do
          Disciplines::MostAccessedQuery.call
        end
    end
  end
end
