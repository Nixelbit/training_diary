require "test_helper"

class ExerciseSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @workout = create(:workout, user: @user)
    @workout_exercise = create(:workout_exercise, workout: @workout)
    @exercise_set = create(:exercise_set, workout_exercise: @workout_exercise)
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

  test "update saves changes and redirects to workout" do
    patch exercise_set_path(@exercise_set), params: {
      exercise_set: { repetitions: 50 }
    }

    assert_redirected_to workout_path(@workout)
    assert_equal 50, @exercise_set.reload.repetitions
  end

  test "update with invalid params re-renders the form" do
    original_repetitions = @exercise_set.repetitions

    patch exercise_set_path(@exercise_set), params: {
      exercise_set: { repetitions: nil }
    }

    assert_response :unprocessable_content
    assert_equal original_repetitions, @exercise_set.reload.repetitions
    assert_select "[data-test-id='exercise-set-update-form']"
    assert_select "[data-test-id='exercise-set-form-errors']"
  end

  test "destroy removes the exercise_set" do
    assert_difference("ExerciseSet.count", -1) do
      delete exercise_set_path(@exercise_set)
    end

    assert_redirected_to workout_path(@workout)
    assert_equal "Подход удален", flash[:notice]
  end
end
