FactoryBot.define do
  factory :question do
    statement { Faker::Lorem.sentence }
    text { Faker::Lorem.sentence }
    answer { %w[A B C D].sample }
    daily_access { 100 }
    discipline { Faker::Lorem.sentence }
  end
end
