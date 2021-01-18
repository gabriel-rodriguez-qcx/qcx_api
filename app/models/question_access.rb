class QuestionAccess < ApplicationRecord
  belongs_to :question

  validates :times_accessed, :date, presence: true
  validates :times_accessed, numericality: true

  scope :by_year, ->(year) { where(date: Date.new(year.to_i)...Date.new(year.to_i + 1)) }
  scope :by_month, lambda { |year, month|
    where(date: Date.new(year.to_i, month.to_i)..Date.new(year.to_i, month.to_i).end_of_month)
  }

  scope :by_week, lambda { |year, week_number|
    beginning_of_week = Date.commercial(year.to_i, week_number.to_i)

    where(date: beginning_of_week...beginning_of_week + 7.days)
  }
end
