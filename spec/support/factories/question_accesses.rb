FactoryBot.define do
  factory :question_access do
    question

    times_accessed { 5000 }
    date { Time.zone.today }
  end
end
