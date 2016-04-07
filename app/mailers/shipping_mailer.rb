class ShippingMailer < ApplicationMailer
  def gift_shipped_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Your gift is on its way!')
  end
end
