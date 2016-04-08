class ThankYouMailer < ApplicationMailer
  def thank_you_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'Thank you for your generosity!')
  end
end
