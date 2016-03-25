require 'spec_helper'

describe 'admin users page' do
  include AdminSpecHelper

  before :each do
    login_as_admin_feature
  end

  describe "#show" do
    before :each do
      @user = FactoryGirl.create(:user)

      visit admin_user_path(@user)
    end

    it "displays a user" do
      expect(page).to have_content(@user.name)
    end

    context "therapist users" do
      before :each do
        @user = FactoryGirl.create(:therapist_user)

        visit admin_user_path(@user)
      end

      it "displays wishlists" do
        wishlist = FactoryGirl.create(:list, therapist: @user.role)

        visit admin_user_path(@user)
        expect(page).to have_content(wishlist.title)
      end

      it "says 'no wishlists' if no wishlists" do
        expect(page).to have_content("No Wishlists")
      end
    end

    context "donor users" do
      before :each do
        @user = FactoryGirl.create(:donor_user)

        visit admin_user_path(@user)
      end

      it "displays reservations" do
        reservation = FactoryGirl.create(:reservation, donor: @user.role)

        visit admin_user_path(@user)
        expect(page).to have_content(reservation.gift_request.link)
      end

      it "says 'no reservations' if no reservations" do
        expect(page).to have_content("No Reservations")
      end
    end
  end

  describe "#index" do
    before :each do
      @user_a = FactoryGirl.create(:admin_user)
      @user_b = FactoryGirl.create(:donor_user)

      visit admin_users_path
    end

    it "displays some users" do
      [@user_a, @user_b].each do |user|
        expect(page).to have_content(user.name)
      end
    end
  end

end
