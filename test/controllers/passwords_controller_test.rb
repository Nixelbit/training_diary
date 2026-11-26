require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "renders the reset request form" do
    get new_password_path

    assert_response :success
    assert_select "[data-test-id='password-request-form']"
  end

  test "enqueues a reset email and redirects" do
    post passwords_path, params: { email_address: @user.email_address }

    assert_enqueued_email_with PasswordsMailer, :reset, args: [ @user ]
    assert_redirected_to sign_in_path
    assert_equal "Инструкции по сбросу пароля отправлены (если пользователь с таким адресом существует).", flash[:notice]
  end

  test "create for an unknown user redirects but sends no mail" do
    post passwords_path, params: { email_address: "missing-user@example.com" }

    assert_enqueued_emails 0
    assert_redirected_to sign_in_path
    assert_equal "Инструкции по сбросу пароля отправлены (если пользователь с таким адресом существует).", flash[:notice]
  end

  test "renders the password reset form" do
    get edit_password_path(@user.password_reset_token)

    assert_response :success
    assert_select "[data-test-id='password-edit-form']"
  end

  test "edit with invalid password reset token" do
    get edit_password_path("invalid token")

    assert_redirected_to new_password_path
    assert_equal "Ссылка для сброса пароля недействительна или устарела.", flash[:alert]
  end

  test "updates the password with a valid token" do
    sign_in_as(@user)

    assert_changes -> { @user.reload.password_digest } do
      assert_difference -> { @user.sessions.count }, -1 do
        put password_path(@user.password_reset_token), params: {
          password: "newpassword", password_confirmation: "newpassword"
        }
      end
    end

    assert_redirected_to sign_in_path
    assert_equal "Пароль был сброшен.", flash[:notice]
  end

  test "does not update the password when they do not match" do
    token = @user.password_reset_token

    assert_no_changes -> { @user.reload.password_digest } do
      put password_path(token), params: {
        password: "newpassword", password_confirmation: "differentpassword"
      }
    end

    assert_redirected_to edit_password_path(token)
    assert_equal "Пароли не совпадают.", flash[:alert]
  end
end
