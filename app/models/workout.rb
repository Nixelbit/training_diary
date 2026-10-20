class Workout < ApplicationRecord
  belongs_to :user
  has_many :workout_exercises, dependent: :destroy

  validates :name, presence: true
  validates :date, presence: true
end
