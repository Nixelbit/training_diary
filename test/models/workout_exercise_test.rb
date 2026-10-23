require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  test "is valid with factory defaults" do
    assert build(:workout_exercise).valid?
  end

  test "is invalid without workout" do
    workout_exercise = build(:workout_exercise, workout: nil)

    refute workout_exercise.valid?
    assert workout_exercise.errors.of_kind?(:workout, :blank)
  end

  test "is invalid without exercise" do
    workout_exercise = build(:workout_exercise, exercise: nil)

    refute workout_exercise.valid?
    assert workout_exercise.errors.of_kind?(:exercise, :blank)
  end

  test "is invalid without position" do
    workout_exercise = build(:workout_exercise, position: nil)

    refute workout_exercise.valid?
    assert workout_exercise.errors.of_kind?(:position, :not_a_number)
  end

  test "is invalid with non-integer position" do
    workout_exercise = build(:workout_exercise, position: 1.5)

    refute workout_exercise.valid?
    assert workout_exercise.errors.of_kind?(:position, :not_an_integer)
  end

  test "is invalid with zero or negative position" do
    [ 0, -1 ].each do |value|
      workout_exercise = build(:workout_exercise, position: value)

      refute workout_exercise.valid?
      assert workout_exercise.errors.of_kind?(:position, :greater_than)
    end
  end

  test "is invalid with duplicate position in same workout" do
    workout = create(:workout)
    create(:workout_exercise, workout: workout, position: 1)
    duplicate = build(:workout_exercise, workout: workout, position: 1)

    refute duplicate.valid?
    assert duplicate.errors.of_kind?(:position, :taken)
  end

  test "allows same position in different workouts" do
    create(:workout_exercise, workout: create(:workout), position: 1)
    other = build(:workout_exercise, workout: create(:workout), position: 1)

    assert other.valid?
  end

  test "destroys associated exercise_sets" do
    workout_exercise = create(:workout_exercise)
    exercise_set = create(:exercise_set, workout_exercise: workout_exercise)

    assert_difference("ExerciseSet.count", -1) { workout_exercise.destroy }
    refute ExerciseSet.exists?(exercise_set.id)
  end
end
