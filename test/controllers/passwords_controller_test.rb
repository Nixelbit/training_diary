require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "renders the reset request form" do
    get new_password_path
    assert_response :success
  end

  test "enqueues a reset email and redirects" do
    post passwords_path, params: { email_address: @user.email_address }
    assert_enqueued_email_with PasswordsMailer, :reset, args: [ @user ]
    assert_redirected_to sign_in_path

    follow_redirect!
    assert_notice "Инструкции по сбросу пароля отправлены"
  end

  test "create for an unknown user redirects but sends no mail" do
    post passwords_path, params: { email_address: "missing-user@example.com" }
    assert_enqueued_emails 0
    assert_redirected_to sign_in_path

    follow_redirect!
    assert_notice "Инструкции по сбросу пароля отправлены"
  end

  test "renders the password reset form" do
    get edit_password_path(@user.password_reset_token)
    assert_response :success
  end

  test "edit with invalid password reset token" do
    get edit_password_path("invalid token")
    assert_redirected_to new_password_path

    follow_redirect!
    assert_notice "Ссылка для сброса пароля недействительна"
  end

  test "updates the password with a valid token" do
    assert_changes -> { @user.reload.password_digest } do
      put password_path(@user.password_reset_token), params: { password: "new", password_confirmation: "new" }
      assert_redirected_to sign_in_path
    end

    follow_redirect!
    assert_notice "Пароль был сброшен"
  end

  test "does not update the password when they do not match" do
    token = @user.password_reset_token
    assert_no_changes -> { @user.reload.password_digest } do
      put password_path(token), params: { password: "no", password_confirmation: "match" }
      assert_redirected_to edit_password_path(token)
    end

    follow_redirect!
    assert_notice "Пароли не совпадают"
  end

  private

  def assert_notice(text)
    assert_select("div", /#{text}/)
  end
end
