module Disciplines
  class MostAccessedQuery
    def self.call(limit = 10)
      Question.group(:discipline).order('sum_daily_access desc').limit(limit).sum(:daily_access) || {}
    end
  end
end
