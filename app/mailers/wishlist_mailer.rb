class WishlistMailer < ApplicationMailer
  def wish_list_creation_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'Congratulations for creating a wishlist!')
  end
  def item_purchased_email(user)
    @user = user
    @url  = login_url
    mail(to: @user.email, subject: 'You have purchased an item you reserved')
  end
end
