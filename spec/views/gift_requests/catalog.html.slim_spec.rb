require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'gift_requests/catalog.html.slim', type: :view do
  before :each do
    @user = FactoryGirl.create(:therapist_user)
    @event = FactoryGirl.create(:event).decorate
    @list = FactoryGirl.create(:list, event: @event, therapist: @user.role)
    FactoryGirl.create_list(:gift_request, 3, list_id: @list.id)
    @gift_requests = GiftRequest.all.page(1)
    render template: 'gift_requests/catalog'
    page = Capybara::Node::Simple.new(rendered)
  end

  it "renders all gift requests" do
    @gift_requests.each do |gr|
      expect(rendered).to have_text(gr.name)
    end
  end

  it "displays the shipping deadline" do
    expect(rendered).to have_text(@event.pretty_end_date)
  end
end
