class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail(subject: "Сброс пароля", to: user.email_address)
  end
end
