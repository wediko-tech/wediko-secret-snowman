require 'spec_helper'

describe 'admin wishlists page' do
  include AdminSpecHelper

  before :each do
    login_as_admin_feature
  end

  describe "#show" do
    before :each do
      @wishlist = FactoryGirl.create(:list, :with_requests, description: "long" * 50)

      visit admin_wishlist_path(@wishlist)
    end

    it "shows a wishlist" do
      expect(page).to have_content(@wishlist.title)
    end

    it "shows the entire description" do
      # does not truncate
      expect(page).to have_content(@wishlist.description)
    end

    context "with some gift requests" do
      it "lets you delete all associated gift requests" do
        expect(page).to have_content("Delete all requests")
        click_on "Delete all requests"

        expect(page).to have_content("Gift requests deleted.")
        expect(@wishlist.gift_requests.count).to eq 0
      end

      it "shows requests under a wishlist" do
        @wishlist.gift_requests.each do |req|
          expect(page).to have_content(req.recipient)
        end

        # finds reqquests panel
        expect(page).to have_selector(:xpath, "//div[@class=\"panel\"]/*[text()=\"Requests\"]")
      end
    end

    context "with no gift requests" do
      before :each do
        @wishlist.gift_requests.destroy_all

        visit admin_wishlist_path(@wishlist)
      end

      it "does not show the requests panel" do
        # finds div.panel with a child node containing the text "Requests"
        expect(page).to have_no_selector(:xpath, "//div[@class=\"panel\"]/*[text()=\"Requests\"]")
      end

      it "does not show the option to delete associated requests" do
        expect(page).to have_no_content("Delete all requests")
      end
    end
  end

  describe "#index" do
    before :each do
      @wishlist = FactoryGirl.create(:list)
      @long_desc_wishlist = FactoryGirl.create(:list, description: "long" * 50)

      visit admin_wishlists_path
    end

    it "displays some wishlists" do
      expect(page).to have_content(@wishlist.title)
      expect(page).to have_content(@long_desc_wishlist.title)
    end

    it "truncates long descriptions after 50 characters" do
      expect(page).to have_content(@long_desc_wishlist.description.truncate(50))
    end

    it "does not let you create a new list" do
      expect(page).to have_no_content("New Wishlist")
    end
  end

end
