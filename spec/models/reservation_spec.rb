require 'spec_helper'

describe Reservation do
  before(:each) do
    @reservation = FactoryGirl.create(:reservation)
  end

  it 'has a valid factory' do
    expect(@reservation).to be_valid
  end

  it 'defaults to a state of reserved' do
    expect(@reservation).to be_reserved
  end

  it 'handles state change of reserved to shipped correctly' do
    @reservation.update_attributes(shipment_method: "aaa", tracking_number: "bbb")
    @reservation.ship!
    expect(@reservation).to be_shipped
    #mailer tests here
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to include('Your purchase was successful')
  end

  it "restricts shipping if shipment method is missing" do
    @reservation.ship
    expect(@reservation).to be_reserved
    expect(@reservation.errors).not_to be_empty
  end

  it "allows shipping if only tracking number is missing" do
    @reservation.update_attributes(shipment_method: "well trained squirrel")
    @reservation.ship
    expect(@reservation).to be_shipped
    expect(@reservation.errors).to be_empty
  end

  context "shipped" do
    before :each do
      @shipped_reservation = FactoryGirl.create(:shipped_reservation)
    end

    it 'handles state change of shipped to received correctly', inline_jobs: true do
      @shipped_reservation.receive!
      expect(@shipped_reservation.state).to eq('received')
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.subject).to include('Thank you for your generosity!')
    end

    it 'handles cancellation state change correctly' do
      @shipped_reservation.cancel
      expect(@shipped_reservation.state).to eq('reserved')
    end

    it 'restricts cancellation if gift has been received' do
      @shipped_reservation.receive
      expect(@shipped_reservation.cancel).to be false
    end
  end
end
