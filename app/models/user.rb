class User < ApplicationRecord
  has_many :workouts

  has_many :workout_exercises, through: :workouts
  has_many :exercise_sets, through: :workout_exercises
end
