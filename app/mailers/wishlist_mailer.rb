class WishlistMailer < ApplicationMailer
  #he purpose of the wishlist creation email is to give confirmation to the therapist that the wishlist was successfully created
  def wish_list_creation_email(therapist)
    @therapist = therapist
    @url  = login_url
    mail(to: @therapist.email, subject: 'Your wishlist has been created.')
  end
  def item_purchased_email(donor)
    @donor = donor
    @url  = login_url
    mail(to: @donor.email, subject: 'Your purchase was successful')
  end
end
