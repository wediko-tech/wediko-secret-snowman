class ShippingMailer < ApplicationMailer
  #this class is to notify Wediko that a donor has filled out the gift shipped
  #form and has successfully bought a gift
  #edit mailer body to include donor and gift info
  def gift_shipped_email(reservation_id)
    @reservation = Reservation.find(reservation_id)
    @url  = login_url
    mail(to: Rails.configuration.wediko_notification_address, subject: 'A gift has been shipped.')
  end
end
