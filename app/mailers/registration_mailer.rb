class RegistrationMailer < ApplicationMailer
  def registration_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'Thank you for registering')
  end
end
