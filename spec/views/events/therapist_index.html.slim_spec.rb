require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'events/therapist_index.html.slim', type: :view do
  before :each do
    login_as_therapist
  end

  it 'should render all events' do
    @events = EventDecorator.decorate_collection(FactoryGirl.create_list(:event, 3))

    render template: 'events/therapist_index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody tr.event').length).to eq(@events.length)
    expect(rendered).to have_text('Title')
    expect(rendered).to have_text('Description')
  end

  it 'should render an empty message if there are no events' do
    @events = []

    render template: 'events/therapist_index'
    page = Capybara::Node::Simple.new(rendered)

    expect(page.all('tbody').length).to eq(0)
    expect(rendered).to have_text("No events exist!")
  end
end
