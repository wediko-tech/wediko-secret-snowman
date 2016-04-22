class RegistrationMailer < ApplicationMailer
  def registration_email(user_id)
    #this is a special mailer common to all users, so don't specify it for a role
    @user = User.find(user_id)
    @url  = login_url
    mail(to: @user.email, subject: 'Thank you for registering')
  end
end
