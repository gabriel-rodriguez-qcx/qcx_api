class QuestionAccess < ApplicationRecord
  belongs_to :question

  validates :times_accessed, :date, presence: true
  validates :times_accessed, numericality: true
end
