class LateReservationMailer < ApplicationMailer
  def forgot_to_buy_gift_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'Please check your gift reservations!')
  end
end
