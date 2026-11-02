FactoryBot.define do
  factory :exercise_set do
    workout_exercise
    weight { 60.5 }
    repetitions { 10 }
    sequence(:position) { |n| n }
    notes { "comment" }
  end
end
