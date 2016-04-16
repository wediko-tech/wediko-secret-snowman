require 'spec_helper'
include AdminSpecHelper
include LoginHelper

RSpec.describe ReservationsController, type: :controller do

  before(:each) do
    login_as_donor
    @therapist = FactoryGirl.create(:therapist_user)
    @list = FactoryGirl.create(:list, therapist: @therapist.role)
    @gift_request = FactoryGirl.create(:gift_request, list_id: @list.id)
    @reservation = FactoryGirl.create(:reservation, gift_request_id: @gift_request.id, donor_id: @user.id)
  end


  describe "POST #ship" do
    it "moves a reservation from reserved to shipped" do

      expect(@reservation.state).to eq('reserved')

      post :ship, id: @reservation.id

      expect(response).to redirect_to login_path

      @reservation.reload
      expect(@reservation.state).to eq('shipped')
    end
  end


  describe "POST #receive" do
    it "moves a reservation from reserved to shipped" do
      login_as_admin

      expect(@reservation.state).to eq('reserved')

      @reservation.ship
      expect(@reservation.state).to eq('shipped')

      post :receive, id: @reservation.id

      expect(response).to redirect_to login_path

      @reservation.reload
      expect(@reservation.state).to eq('received')
    end

    it "returns unauthorized unless user is admin" do

      expect(@reservation.state).to eq('reserved')

      @reservation.ship
      expect(@reservation.state).to eq('shipped')

      post :receive, id: @reservation.id

      expect(response).to redirect_to root_path

      expect(@reservation.state).to eq('shipped')
    end
  end



end