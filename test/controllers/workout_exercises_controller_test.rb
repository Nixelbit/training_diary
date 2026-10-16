require "test_helper"

class WorkoutExercisesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get workout_exercises_create_url
    assert_response :success
  end
end
