class ShippingMailer < ApplicationMailer
  def gift_shipped_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'Your gift is on its way!')
  end
end
