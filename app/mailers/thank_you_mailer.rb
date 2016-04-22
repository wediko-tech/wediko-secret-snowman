class ThankYouMailer < ApplicationMailer
  def thank_you_email(donor_id)
    @donor = User.find(donor_id)
    @url  = login_url
    mail(to: @donor.email, subject: 'Thank you for your generosity!')
  end
end
