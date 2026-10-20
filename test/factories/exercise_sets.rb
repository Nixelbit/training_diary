FactoryBot.define do
  factory :exercise_set do
    workout_exercise
    weight { 60.5 }
    repetitions { 10 }
    position { 1 }
    notes { nil }
  end
end
