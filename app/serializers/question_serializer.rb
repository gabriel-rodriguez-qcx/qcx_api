class QuestionSerializer < ApplicationSerializer
  attributes :statement, :text, :answer, :daily_access, :discipline
  type :question

  attribute :times_accessed do
    scope ? scope[object.id] : 'N/A'
  end
end
