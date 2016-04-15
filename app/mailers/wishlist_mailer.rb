class WishlistMailer < ApplicationMailer
  #he purpose of the wishlist creation email is to give confirmation to the therapist that the wishlist was successfully created
  def wish_list_creation_email(donor)
    @donor = donor
    @url  = login_url
    mail(to: @donor.email, subject: 'Congratulations for creating a wishlist!')
  end
  def item_purchased_email(donor)
    @donor = donor
    @url  = login_url
    mail(to: @donor.email, subject: 'You have purchased an item you reserved')
  end
end
