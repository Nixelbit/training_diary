class ExerciseSet < ApplicationRecord
  belongs_to :workout_exercise

  validates :repetitions, numericality: {
      only_integer: true, greater_than: 0, less_than: 10_000
    }

  validates :weight, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 999.99
  }

  validates :position, uniqueness: { scope: :workout_exercise_id },
    numericality: { only_integer: true, greater_than: 0 }

  validates :notes, length: { maximum: 2_000 }, allow_blank: true
end
