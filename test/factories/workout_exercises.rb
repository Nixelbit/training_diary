FactoryBot.define do
  factory :workout_exercise do
    workout
    exercise
    position { 1 }
  end
end
