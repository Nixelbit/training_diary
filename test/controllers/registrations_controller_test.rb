require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "renders the registration form" do
    get sign_up_path

    assert_response :success
    assert_select "[data-test-id='registration-create-form']"
  end

  test "create registers the user, signs them in and redirects" do
    assert_difference("User.count", 1) do
      post sign_up_path, params: {
        user: { email_address: "test@example.com", password: "password", password_confirmation: "password" }
      }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid params re-renders the form" do
    assert_no_difference("User.count") do
      post sign_up_path, params: {
        user: { email_address: "", password: "password", password_confirmation: "password" }
      }
    end

    assert_response :unprocessable_content

    assert_select "[data-test-id='registration-create-form']"
    assert_select "[data-test-id='registration-form-errors']"
  end
end
