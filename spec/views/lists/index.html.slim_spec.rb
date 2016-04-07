require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'lists/index.html.slim', type: :view do

  it 'should render all lists for a therapist' do
    login_as_therapist
    @lists = FactoryGirl.create_list(:list, 3, therapist: @user.role)

    render template: 'lists/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody tr.request').length).to eq(@lists.length)
    expect(rendered).to have_text('Title')
    expect(rendered).to have_text('Description')
  end

  it 'should render the empty message if there are no wishlists' do
    login_as_therapist
    @lists = [];

    render template: 'lists/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody').length).to eq(0)
    expect(rendered).to have_text("No wishlists have been created yet!")
  end
end
