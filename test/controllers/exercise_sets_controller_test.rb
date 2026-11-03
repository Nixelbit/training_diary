require "test_helper"

class ExerciseSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @workout = create(:workout, user: @user)
    @workout_exercise = create(:workout_exercise, workout: @workout)
  end

  test "create exercise_set and redirects to workout" do
    position = @workout_exercise.exercise_sets.maximum(:position).to_i + 1

    assert_difference("ExerciseSet.count", 1) do
      post workout_workout_exercise_exercise_sets_path(@workout, @workout_exercise), params: {
        exercise_set: { weight: 50, repetitions: 10, position: position }
      }
    end

    assert_redirected_to workout_path(@workout)

    exercise_set = @workout_exercise.exercise_sets.order(:id).last
    assert_equal @workout_exercise, exercise_set.workout_exercise
    assert_equal 50, exercise_set.weight
    assert_equal 10, exercise_set.repetitions
    assert_equal position, exercise_set.position
  end

  test "create with invalid params re-renders the show page" do
    assert_no_difference("ExerciseSet.count") do
      post workout_workout_exercise_exercise_sets_path(@workout, @workout_exercise), params: {
        exercise_set: { repetitions: nil, position: nil }
      }
    end

    assert_response :unprocessable_content
    assert_select "[data-test-id='exercise-set-create-form']"
    assert_select "[data-test-id='exercise-set-form-errors']"
  end
end
