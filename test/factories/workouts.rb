FactoryBot.define do
  factory :workout do
    user
    sequence(:name) { |n| "Тренировка #{n}" }
    date { Time.now.utc.to_date }
  end
end
