module Disciplines
  class MostAccessedQuery
    def self.call
      Question.group(:discipline).order('sum_daily_access desc').limit(10).sum(:daily_access)
    end
  end
end
