class WishlistMailer < ApplicationMailer
  #he purpose of the wishlist creation email is to give confirmation to the therapist that the wishlist was successfully created
  def wish_list_creation_email(therapist_id)
    @therapist = User.find(therapist_id)
    @url  = login_url
    mail(to: @therapist.email, subject: 'Your wishlist has been created.')
  end
  def item_purchased_email(donor_id, reservation_id)
    @donor = User.find(donor_id)
    @reservation = Reservation.find(reservation_id)
    @url  = login_url
    mail(to: @donor.email, subject: 'Your purchase was successful')
  end
end
