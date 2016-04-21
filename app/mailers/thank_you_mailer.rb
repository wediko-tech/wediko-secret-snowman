class ThankYouMailer < ApplicationMailer
  def thank_you_email(donor)
    @donor = donor
    @url  = login_url
    mail(to: @donor.email, subject: 'Thank you for your generosity!')
  end
end
