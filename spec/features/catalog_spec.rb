require 'spec_helper'
include AdminSpecHelper

describe 'catalog', type: :feature do
  before :each do
    @user = FactoryGirl.create(:therapist_user)
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, event: @event, therapist: @user.role)
    @gift_requests = FactoryGirl.create_list(:gift_request, 3, list_id: @list.id)

    login_as_therapist_feature(@user)
  end

  it "renders the catalog for an event" do
    visit catalog_event_path(id: @event.id)

    @gift_requests.each do |gr|
      expect(page).to have_content(gr.name)
    end
  end

  it "renders only unreserved requests" do
    gr = @gift_requests.first
    FactoryGirl.create(:reservation, gift_request: gr)

    visit catalog_event_path(id: @event.id)
    expect(page).not_to have_content(gr.name)
  end
end
