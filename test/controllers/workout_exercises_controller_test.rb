require "test_helper"

class WorkoutExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @workout = create(:workout, user: @user)
    @exercise = create(:exercise)
  end

  test "create workout_exercise and redirects to workout" do
    position = @workout.workout_exercises.maximum(:position).to_i + 1

    assert_difference("WorkoutExercise.count", 1) do
      post workout_workout_exercises_url(@workout), params: {
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
      post workout_workout_exercises_url(@workout), params: {
        workout_exercise: { exercise_id: "", position: "" }
      }
    end

    assert_response :unprocessable_content
    assert_select "[data-test-id='workout-exercise-create-form']"
  end
end
