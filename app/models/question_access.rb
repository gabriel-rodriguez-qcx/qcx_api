class QuestionAccess < ApplicationRecord
  searchkick

  belongs_to :question

  validates :times_accessed, :date, presence: true
  validates :times_accessed, numericality: true

  scope :by_year, lambda { |year|
    year = Date.new(year.to_i)

    where(date: year..year.end_of_year.end_of_day)
  }

  scope :by_month, lambda { |year, month|
    month = Date.new(year.to_i, month.to_i)

    where(date: month..month.end_of_month.end_of_day)
  }

  scope :by_week, lambda { |year, week_number|
    week = Date.commercial(year.to_i, week_number.to_i)

    where(date: week..week.end_of_week.end_of_day)
  }
end
