class Question < ApplicationRecord
  has_many :question_accesses, dependent: :destroy

  validates :statement, :text, :answer, :daily_access, :discipline, presence: true
  validates :daily_access, numericality: true
  validates :answer, inclusion: { in: %w[A B C D] }
end
