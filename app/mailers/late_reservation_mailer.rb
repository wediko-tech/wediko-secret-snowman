class LateReservationMailer < ApplicationMailer
  def forgot_to_buy_gift_email(donor, delinquencies)
    @donor = donor
    @delinquencies = delinquencies
    @url  = login_url
    mail(to: @donor.email, subject: 'Please check your gift reservations!')
  end
end
