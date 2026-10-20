require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "is invalid without a name" do
    workout = build(:workout, name: nil)

    refute workout.valid?
    assert workout.errors.of_kind?(:name, :blank)
  end

  test "is invalid without a date" do
    workout = build(:workout, date: nil)

    refute workout.valid?
    assert workout.errors.of_kind?(:date, :blank)
  end

  test "is invalid without a user" do
    workout = build(:workout, user: nil)

    refute workout.valid?
    assert workout.errors.of_kind?(:user, :blank)
  end

  test "belongs to a user" do
    user = create(:user)
    workout = create(:workout, user: user)

    assert_equal user.id, workout.user.id
  end

  test "destroying a workout destroys its exercises and their sets" do
    workout = create(:workout)
    workout_exercise = create(:workout_exercise, workout: workout)
    exercise_sets = create_list(:exercise_set, 3, workout_exercise: workout_exercise)

    workout.destroy

    refute WorkoutExercise.exists?(workout_exercise.id)
    assert_empty ExerciseSet.where(id: exercise_sets.map { it.id })
  end

  test "destroying a workout leaves other workouts intact" do
    other_workout = create(:workout)
    workout = create(:workout)

    workout.destroy

    assert Workout.exists?(other_workout.id)
  end
end
