class ThankYouMailer < ApplicationMailer
  def thank_you_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Thank you for your generosity!')
  end
end
