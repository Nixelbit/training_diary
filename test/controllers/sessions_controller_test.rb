require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "renders the login form" do
    get sign_in_path

    assert_response :success
    assert_select "[data-test-id='session-create-form']"
  end

  test "signs in with valid credentials" do
    post sign_in_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "does not sign in with invalid credentials" do
    post sign_in_path, params: { email_address: @user.email_address, password: "wrongpassword" }

    assert_redirected_to sign_in_path
    assert_nil cookies[:session_id]
    assert_equal "Проверьте адрес электронной почты и пароль.", flash[:alert]
  end

  test "signs out and clears the session cookie" do
    sign_in_as(@user)

    delete sign_out_path

    assert_redirected_to sign_in_path
    assert_empty cookies[:session_id]
  end
end
