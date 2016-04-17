require 'spec_helper'
include LoginHelper

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

  describe 'filtering' do
    context "gender" do
      before :each do
        @male_req = FactoryGirl.create(:gift_request, gender: "M", list_id: @list.id)
        @female_req = FactoryGirl.create(:gift_request, gender: "F", list_id: @list.id)
      end

      it "lets you filter by gender" do
        visit catalog_event_path(id: @event.id)
        choose "gender_F"
        click_on "Filter"

        expect(page).not_to have_content(@male_req.name)
        expect(page).to have_content(@female_req.name)
      end

      # [SJP] apologies to nonbinary people
      it "ignores any gender filter other than male/female" do
        visit catalog_event_path(id: @event.id, gender: "something")

        expect(page).to have_content(@male_req.name)
        expect(page).to have_content(@female_req.name)
      end
    end

    context "age" do
      before :each do
        @young_req = FactoryGirl.create(:gift_request, age: 5, list_id: @list.id)
        @old_req = FactoryGirl.create(:gift_request, age: 85, list_id: @list.id)
      end

      it "lets you filter by age" do
        visit catalog_event_path(id: @event.id)
        fill_in :min_age, with: 3
        fill_in :max_age, with: 10
        click_on "Filter"

        expect(page).not_to have_content(@old_req.name)
        expect(page).to have_content(@young_req.name)
      end

      it "defaults to 200 when max value is missing" do
        visit catalog_event_path(id: @event.id)
        fill_in :min_age, with: 6
        click_on "Filter"

        expect(page).to have_content(@old_req.name)
        expect(page).not_to have_content(@young_req.name)
      end

      it "defaults to 0 when min value is missing" do
        visit catalog_event_path(id: @event.id)
        fill_in :max_age, with: 60
        click_on "Filter"

        expect(page).not_to have_content(@old_req.name)
        expect(page).to have_content(@young_req.name)
      end
    end
  end
end
