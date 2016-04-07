class LateReservationMailer < ApplicationMailer
  def forgot_to_buy_gift_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Please check your gift reservations!')
  end
end
