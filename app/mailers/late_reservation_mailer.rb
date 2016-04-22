class LateReservationMailer < ApplicationMailer
  def forgot_to_buy_gift_email(donor_id, delinquencies)
    @donor = User.find(donor_id)
    @delinquencies = delinquencies
    @url  = login_url
    mail(to: @donor.email, subject: 'Please check your gift reservations!')
  end

  def delinquent_reservation(user_id)
    @user = User.find(user_id)
    @url = login_url

    mail(to: @user.email, subject: "Your gifts are past due.")
  end
end
