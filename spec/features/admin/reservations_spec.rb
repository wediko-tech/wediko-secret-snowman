require 'spec_helper'

describe 'admin reservations page' do
  include AdminSpecHelper

  before :each do
    login_as_admin_feature
  end

  describe "#show" do
    before :each do
      @reservation = FactoryGirl.create(:reservation)

      visit admin_reservation_path(@reservation)
    end

    it "displays a reservation" do
      expect(page).to have_content(@reservation.gift_request.link)
    end

    context "shipped reservation" do
      before :each do
        @reservation = FactoryGirl.create(:shipped_reservation)

        visit admin_reservation_path(@reservation)
      end

      it "allows you to mark the reservation as received" do
        expect(page).to have_content("Mark As Received")
        click_on "Mark As Received"

        expect(page).to have_content "Marked as received"
        expect(@reservation.reload).to be_received
      end
    end

    context "non-shipped reservation" do
      it "does not display the option to mark as received" do
        expect(page).to have_no_content("Mark As Received")
      end
    end

    context "delinquent reservation" do
      before :each do
        @reservation.update_attributes(delinquent: true)

        visit admin_reservation_path(@reservation)
      end

      it "shows 'delinquent' as the reservation status" do
        expect(page).to have_content("Delinquent")
      end

      it "does not display the reservation's state" do
        expect(page).to have_no_content(@reservation.state)
      end
    end

    context "non-delinquent reservation" do
      it "displays the reservation's state as its status" do
        expect(page).to have_content(@reservation.state.capitalize)
      end
    end
  end

  describe "#index" do
    before :each do
      @reservations = []

      2.times do |i|
        @reservations << FactoryGirl.create(:reservation)
      end

      visit admin_reservations_path
    end

    it "displays some reservations" do
      @reservations.each do |r|
        expect(page).to have_content(r.gift_request.link)
      end
    end
  end
end
