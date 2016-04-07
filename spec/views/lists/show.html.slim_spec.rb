require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'lists/show.html.slim', type: :view do

  it 'should render all requests for a wishlist' do
    login_as_therapist
    @list = FactoryGirl.create(:list, :with_requests, therapist: @user.role)
    @requests = @list.gift_requests

    render template: 'lists/show'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody tr.request').length).to eq(@requests.length)
    expect(rendered).to have_text('fakelink')
    expect(rendered).to have_text('Description')
    expect(rendered).to have_text('Recipient')
    expect(rendered).to have_text('Gender')
    expect(rendered).to have_text('Age')
  end

  it 'should render the empty message if there are no requests' do
    login_as_therapist
    @list = FactoryGirl.create(:list, therapist: @user.role)
    @requests = @list.gift_requests

    render template: 'lists/show'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody').length).to eq(0)
    expect(rendered).to have_text("No requests have been created for this wishlist!")
  end
end
