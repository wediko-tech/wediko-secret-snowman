require 'spec_helper'
include LoginHelper

RSpec.describe ReservationsController, type: :controller do

  before(:each) do
    login_as_donor
    @therapist = FactoryGirl.create(:therapist_user)
    @list = FactoryGirl.create(:list, therapist: @therapist.role)
    @gift_request = FactoryGirl.create(:gift_request, list_id: @list.id)
    @reservation = FactoryGirl.create(:reservation, gift_request_id: @gift_request.id, donor_id: @user.role.id)
  end


  describe "PATCH #ship" do
    it "moves a reservation from reserved to shipped" do
      expect(@reservation.state).to eq('reserved')

      patch :ship, id: @reservation.id, reservation: {shipment_method: "something", tracking_number: "something_else"}

      expect(response).to redirect_to reservations_path

      @reservation.reload
      expect(@reservation.state).to eq('shipped')
    end

    it "renders errors on unsuccessful shipping" do
      @shipped_reservation = FactoryGirl.create(:shipped_reservation, donor_id: @user.role.id)
      @shipped_reservation.receive

      patch :ship, id: @shipped_reservation.id, reservation: {shipment_method: "catapult"}

      expect(@shipped_reservation.reload).to be_received
    end

    it "should only be accessible to donors" do
      login_as_therapist

      patch :ship, id: @reservation.id

      expect(response).to redirect_to root_path
    end
  end

  describe "PATCH #cancel" do
    before :each do
      @shipped_reservation = FactoryGirl.create(:shipped_reservation, donor_id: @user.role.id)
    end

    it "moves a reservation from shipped to reserved" do
      expect(@shipped_reservation.state).to eq('shipped')

      patch :cancel, id: @shipped_reservation.id

      expect(response).to redirect_to reservations_path

      @shipped_reservation.reload
      expect(@shipped_reservation.state).to eq('reserved')
    end

    it "fails on unsuccessful cancellation" do
      @shipped_reservation.receive!
      patch :cancel, id: @shipped_reservation.id

      expect(response).to redirect_to reservations_path
      expect(@shipped_reservation.reload).to be_received
    end

    it "should only be accessible to donors" do
      login_as_therapist

      patch :cancel, id: @reservation.id

      expect(response).to redirect_to root_path
    end
  end

  describe "DELETE #destroy" do
    it "deletes a reservation" do
      delete :destroy, id: @reservation.id

      expect(response).to redirect_to reservations_path
      expect(Reservation.all.length).to eq(0)
    end

    it "should not delete received reservations" do
      @shipped_reservation = FactoryGirl.create(:shipped_reservation, donor_id: @user.role.id)
      @shipped_reservation.receive

      expect(@shipped_reservation.state).to eq('received')

      delete :destroy, id: @shipped_reservation.id

      expect(response).to redirect_to reservations_path
      expect(Reservation.find_by_id(@shipped_reservation.id)).not_to be_nil
    end

  end



end
