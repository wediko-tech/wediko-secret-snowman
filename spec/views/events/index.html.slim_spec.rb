require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'events/index.html.slim', type: :view do

  it 'should render all events' do
    login_as_therapist
    @events = EventDecorator.decorate_collection(FactoryGirl.create_list(:event, 3))

    render template: 'events/index'
    page = Capybara::Node::Simple.new(rendered)

    @events.each do |ev|
      expect(rendered).to have_text(ev.title)
    end
  end

  it 'should render an empty message if there are no events' do
    login_as_therapist
    @events = []

    render template: 'events/index'
    page = Capybara::Node::Simple.new(rendered)
    expect(rendered).to have_text("no active events")
  end
end
