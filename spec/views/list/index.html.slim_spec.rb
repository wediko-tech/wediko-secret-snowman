require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'list/index.html.slim', type: :view do

  it 'should render all lists for a therapist' do
    login_as_therapist
    @lists = FactoryGirl.create_list(:list, 3, therapist: @user.role)

    render template: 'list/index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody tr.request').length).to eq(@lists.length)
    expect(rendered).to have_text('Title')
    expect(rendered).to have_text('Description')
  end
end
