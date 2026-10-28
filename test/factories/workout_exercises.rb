FactoryBot.define do
  factory :workout_exercise do
    workout
    exercise
    sequence(:position) { |n| n }
  end
end
