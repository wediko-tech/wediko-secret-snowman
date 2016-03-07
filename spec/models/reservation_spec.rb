require 'rails_helper'

describe Reservation do
  before(:each) do
    @reservation = FactoryGirl.build(:reservation)
  end

  it 'has a valid factory' do
    expect(@reservation).to be_valid
  end

  it 'defaults to a state of unreserved' do
    expect(@reservation.state).to eq('unreserved')
  end

  it 'handles state change of unreserved to reserved correctly' do
    @reservation.reserve
    expect(@reservation.state).to eq('reserved')
  end

  it 'handles state change of reserved to shipped correctly' do
    @reservation.reserve
    @reservation.ship
    expect(@reservation.state).to eq('shipped')
  end

  it 'handles state change of shipped to received correctly' do
    @reservation.reserve
    @reservation.ship
    @reservation.receive
    expect(@reservation.state).to eq('received')
  end

  it 'handles cancellation state changes correctly' do
    @reservation.reserve
    @reservation.cancel
    expect(@reservation.state).to eq('unreserved')

    @reservation.reserve
    @reservation.ship
    @reservation.cancel
    expect(@reservation.state).to eq('reserved')
  end

  it 'restricts cancellation if gift has been received' do
    @reservation.reserve
    @reservation.ship
    @reservation.receive
    expect(@reservation.cancel).to be false
  end
end
