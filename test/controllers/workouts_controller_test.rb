require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @other_user = create(:user)
    @user = create(:user)
    @workout = create(:workout, user: @user)
  end

  test "index shows only current user's workouts" do
    foreign_workout = create(:workout, user: @other_user, name: "Чужая тренировка")

    get workouts_path

    assert_response :success
    assert_select "[data-test-id='workout-name']", text: @workout.name
    assert_select "[data-test-id='workout-name']", text: foreign_workout.name, count: 0
  end

  test "show displays the workout" do
    get workout_path(@workout)

    assert_response :success
    assert_select "[data-test-id='workout-name']", text: @workout.name
    assert_select "[data-test-id='workout-date']", text: @workout.date.to_s
  end

  test "new renders the form" do
    get new_workout_path

    assert_response :success
    assert_select "[data-test-id='workout-create-form']"
  end

  test "create saves a valid workout" do
    post workouts_path, params: { workout: workout_params }

    assert_redirected_to workouts_path

    workout = Workout.find_by(name: "Ноги")
    refute_nil workout
    assert_equal Time.now.utc.to_date, workout.date
  end

  test "create assigns the workout to the current user" do
    post workouts_path, params: { workout: workout_params }

    workout = Workout.find_by(name: "Ноги")
    refute_nil workout
    assert_equal @user.id, workout.user.id
  end

  test "create ignores a user_id passed in params" do
    post workouts_path, params: { workout: workout_params.merge(user_id: @other_user.id) }

    workout = Workout.find_by(name: "Ноги")
    refute_nil workout
    assert_equal @user.id, workout.user.id
  end

  test "create with a blank name renders the form with errors" do
    post workouts_path, params: { workout: workout_params(name: "") }

    assert_response :success
    assert_select "[data-test-id='workout-create-form']"
    assert_select "[data-test-id='workout-name-error']"
  end

  test "edit renders the form" do
    get edit_workout_path(@workout)

    assert_response :success
    assert_select "[data-test-id='workout-update-form']"
  end

  test "update saves changes" do
    patch workout_path(@workout), params: { workout: workout_params(name: "Спина") }

    assert_redirected_to workout_path(@workout)
    assert_equal "Спина", @workout.reload.name
  end

  test "update with a blank name renders the form with errors" do
    original_name = @workout.name

    patch workout_path(@workout), params: { workout: workout_params(name: "") }

    assert_response :success
    assert_select "[data-test-id='workout-update-form']"
    assert_select "[data-test-id='workout-name-error']"
    assert_equal original_name, @workout.reload.name
  end

  test "destroy removes the workout" do
    delete workout_path(@workout)

    refute Workout.exists?(@workout.id)
    assert_redirected_to workouts_path
    assert_equal "Тренировка удалена", flash[:notice]
  end

  test "another user's workout cannot be viewed" do
    foreign_workout = create(:workout, user: @other_user)

    get workout_path(foreign_workout)
    assert_response :not_found

    get edit_workout_path(foreign_workout)
    assert_response :not_found
  end

  test "another user's workout cannot be changed or deleted" do
    foreign_workout = create(:workout, user: @other_user)

    patch workout_path(foreign_workout), params: { workout: workout_params(name: "Взлом") }

    assert_response :not_found
    refute_equal "Взлом", foreign_workout.reload.name

    delete workout_path(foreign_workout)

    assert_response :not_found
    assert Workout.exists?(foreign_workout.id)
  end

  def workout_params(overrides = {})
    {
      name: "Ноги", date: Time.now.utc.to_date.to_s
    }.merge(overrides)
  end
end
