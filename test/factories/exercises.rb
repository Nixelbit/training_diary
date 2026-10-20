FactoryBot.define do
  factory :exercise do
    sequence(:name) { |n| "Упражнение #{n}" }
    target_muscle { "Ноги" }
  end
end
