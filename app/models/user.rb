class User < ApplicationRecord
  has_secure_password
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :sessions, dependent: :destroy

  has_many :workouts

  has_many :workout_exercises, through: :workouts
  has_many :exercise_sets, through: :workout_exercises
end
