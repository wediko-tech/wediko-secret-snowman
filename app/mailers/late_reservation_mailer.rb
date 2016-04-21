class LateReservationMailer < ApplicationMailer
  def forgot_to_buy_gift_email(donor)
    @donor = donor
    @url  = login_url
    mail(to: @donor.email, subject: Rails.configuration.late_reservation_mailer_subject)
  end
end
