class PurchaseOrDonateMailer < ApplicationMailer
  def please_give_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Your help is essential!')
  end
end
