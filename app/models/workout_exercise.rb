class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise
  has_many :exercise_sets, dependent: :destroy

  validates :position,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: :workout_id }
end
