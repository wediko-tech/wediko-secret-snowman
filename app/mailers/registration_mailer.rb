class RegistrationMailer < ApplicationMailer
  def registration_email(user)
    #this is a special mailer common to all users, so don't specify it for a role
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: Rails.configuration.registration_mailer_subject)
  end
end
