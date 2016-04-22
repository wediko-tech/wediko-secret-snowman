require "spec_helper"
RSpec.describe WishlistMailer do
  describe 'wishlist created' do
    before :each do
      @therapist = FactoryGirl.create(:therapist_user)
      @mail = WishlistMailer.wish_list_creation_email(@therapist.id)
    end

    it 'renders correct subject' do
      expect(@mail.subject).to eql('Your wishlist has been created.')
    end
    it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((@mail.from)[0])
    end
    it 'addresses to proper recipient' do
      expect((@mail.to)[0]).to eql(@therapist.email)
    end
    it 'renders correct body' do
      expect(@mail.body).to include('The wishlist was successfully created. You can')
    end
  end

  describe 'purchase from wishlist' do
    before :each do
      @user = FactoryGirl.create(:donor_user)
      @reservation = FactoryGirl.create(:reservation, donor: @user.role)
      @mail = WishlistMailer.item_purchased_email(@user.id, @reservation.id)
    end

    it 'renders correct subject' do
      expect(@mail.subject).to eql('Your purchase was successful')
    end
    it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((@mail.from)[0])
    end
    it 'addresses to proper recipient' do
      expect((@mail.to)[0]).to eql(@user.email)
    end
    it 'renders correct body' do
      expect(@mail.body).to include("We've logged your purchase")
    end
  end
end

