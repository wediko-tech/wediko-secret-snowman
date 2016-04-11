require 'spec_helper'
include AdminSpecHelper

RSpec.describe 'gift_requests/catalog.html.slim', type: :view do
  before :each do
    @user = FactoryGirl.create(:therapist_user)
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, event: @event, therapist: @user.role)
    FactoryGirl.create_list(:gift_request, 3, list_id: @list.id)
    @gift_requests = GiftRequest.all.page(1)
  end

  it "renders all gift requests" do
    render template: 'gift_requests/catalog'
    page = Capybara::Node::Simple.new(rendered)

    @gift_requests.each do |gr|
      expect(rendered).to have_text(gr.name)
    end
  end
end
