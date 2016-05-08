require 'spec_helper'
include LoginHelper

RSpec.describe 'reservations/index.html.slim', type: :view do
  before :each do
    login_as_donor
  end

  it 'should render all reservations for a donor' do
    login_as_donor
    @reservations = ReservationDecorator.decorate_collection(FactoryGirl.create_list(:reservation, 3, donor_id: @user.role))

    render template: 'reservations/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody tr.request').length).to eq(@reservations.length)
    expect(rendered).to have_text('Gift')
    expect(rendered).to have_text('Status')
  end

  it 'should allow you to cancel shipped reservations but not ship them' do
    @reservations = [FactoryGirl.create(:shipped_reservation, donor: @user.role).decorate]

    render template: 'reservations/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(rendered).to have_text('Cancel Shipment')
    expect(rendered).not_to have_text('Mark Shipped')
  end

  it 'should allow you to ship unshipped reservations but not cancel them' do
    @reservations = [FactoryGirl.create(:reservation, donor_id: @user.role).decorate]

    render template: 'reservations/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(rendered).not_to have_text('Cancel Shipment')
    expect(rendered).to have_text('Mark Shipped')
  end

  it 'should render the empty message and link you to events if there are no reservations' do
    login_as_donor
    @reservations = []

    render template: 'reservations/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody').length).to eq(0)
    expect(rendered).to have_text("You have no reserved gifts")
    expect(rendered).to have_text("Click here to find a gift")
  end
end
