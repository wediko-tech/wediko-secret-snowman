require 'spec_helper'

describe 'admin gift requests page' do
  include AdminSpecHelper

  before :each do
    login_as_admin_feature
  end

  describe "#show" do
    before :each do
      @gift_request = FactoryGirl.create(:gift_request)

      visit admin_gift_request_path(@gift_request)
    end

    it "displays a gift request" do
      expect(page).to have_content(@gift_request.link)
    end
  end

  describe "#index" do
    before :each do
      @reserved_gift_request = FactoryGirl.create(:reserved_gift_request)
      @unreserved_gift_request = FactoryGirl.create(:gift_request)

      visit admin_gift_requests_path
    end

    it "displays some gift requests" do
      expect(page).to have_content(@reserved_gift_request.link)
      expect(page).to have_content(@unreserved_gift_request.link)
    end

    it "links to a gift request's reservation" do
      expect(page).to have_link(@reserved_gift_request.reservation.state.capitalize,
        href: admin_reservation_path(@reserved_gift_request.reservation))
    end
  end

end
