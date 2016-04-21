class ThankYouMailer < ApplicationMailer
  def thank_you_email(donor)
    @donor = donor
    @url  = login_url
    mail(to: @donor.email, subject: Rails.configuration.thank_you_email_subject)
  end
end
