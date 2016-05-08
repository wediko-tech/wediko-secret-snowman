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

    shared_examples "a receivable reservation" do
      it "allows you to mark the reservation as received" do
        expect(page).to have_content("Mark As Received")
        click_on "Mark As Received"

        expect(page).to have_content "Marked as received"
        expect(@reservation.reload).to be_received
      end
    end

    it "displays a reservation" do
      expect(page).to have_content(@reservation.gift_request.link)
    end

    context "shipped reservation" do
      before :each do
        @reservation = FactoryGirl.create(:shipped_reservation)

        visit admin_reservation_path(@reservation)
      end

      it_behaves_like "a receivable reservation"
    end

    context "non-shipped reservation" do
      it_behaves_like "a receivable reservation"
    end

    context "received reservation" do
      before :each do
        @reservation = FactoryGirl.create(:received_reservation)

        visit admin_reservation_path(@reservation)
      end

      it "does not allow you to mark the reservation as received" do
        expect(page).not_to have_content("Mark As Received")
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

    describe "mass mark received", js: true do
      before :each do
        @reservations << FactoryGirl.create(:received_reservation)

        visit admin_reservations_path
      end

      context "with no received reservations checked" do
        it "marks reservations received" do
          mass_mark_selected(@reservations.reject(&:received?))

          expect(page).to have_content("Marked reservations as received")
          expect(@reservations.map(&:reload).all?(&:received?)).to eq true
        end
      end

      context "with received reservations checked" do
        it "does not mark any reservations as received" do
          previously_unreceived = @reservations.reject(&:received?)
          mass_mark_selected(@reservations)

          expect(page).to have_content("Could not mark as received")
          expect(previously_unreceived.map(&:reload).none?(&:received?)).to eq true
        end
      end

      def mass_mark_selected(reservations)
        reservations.each do |r|
          page.find("#batch_action_item_#{r.id}").set(true)
        end

        click_link "Batch Actions"
        expect(page).to have_content("Mark Received Selected")
        click_link "Mark Received Selected"
        expect(page).to have_selector('.flash')
      end
    end
  end
end
