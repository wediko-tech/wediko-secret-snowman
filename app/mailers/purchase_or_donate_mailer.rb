class PurchaseOrDonateMailer < ApplicationMailer
  def please_give_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'Your help is essential!')
  end
end
