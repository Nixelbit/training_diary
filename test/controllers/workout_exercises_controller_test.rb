require "test_helper"

class WorkoutExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @workout = create(:workout, user: @user)
    @exercise = create(:exercise)
    @workout_exercise = create(:workout_exercise, workout: @workout)
  end

  test "create workout_exercise and redirects to workout" do
    position = @workout.workout_exercises.maximum(:position).to_i + 1

    assert_difference("WorkoutExercise.count", 1) do
      post workout_workout_exercises_path(@workout), params: {
        workout_exercise: { exercise_id: @exercise.id, position: position }
      }
    end

    assert_redirected_to workout_path(@workout)

    workout_exercise = WorkoutExercise.order(:id).last
    assert_equal @workout, workout_exercise.workout
    assert_equal @exercise, workout_exercise.exercise
  end

  test "create with invalid params and re-renders the form" do
    assert_no_difference("WorkoutExercise.count") do
      post workout_workout_exercises_path(@workout), params: {
        workout_exercise: { exercise_id: "", position: "" }
      }
    end

    assert_response :unprocessable_content
    assert_select "[data-test-id='workout-exercise-create-form']"
  end

  test "update saves changes and redirects to workout" do
    new_exercise = create(:exercise)

    patch workout_exercise_path(@workout_exercise), params: {
      workout_exercise: { exercise_id: new_exercise.id }
    }

    assert_redirected_to workout_path(@workout)
    assert_equal new_exercise, @workout_exercise.reload.exercise
  end

  test "update with invalid params re-renders the form" do
    original_position = @workout_exercise.position

    patch workout_exercise_path(@workout_exercise), params: {
      workout_exercise: { position: 0 }
    }

    assert_response :unprocessable_content
    assert_equal original_position, @workout_exercise.reload.position
    assert_select "[data-test-id='workout-exercise-update-form']"
    assert_select "[data-test-id='workout-exercise-create-form']"
  end

  test "destroy removes the workout_exercise" do
    assert_difference("WorkoutExercise.count", -1) do
      delete workout_exercise_path(@workout_exercise)
    end

    assert_redirected_to workout_path(@workout)
    assert_equal "Упражнение удалено", flash[:notice]
  end
end
