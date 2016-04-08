require 'spec_helper'

describe 'admin events page' do
  include AdminSpecHelper

  before :each do
    login_as_admin_feature
  end

  describe "#show" do
    before :each do
      @event = FactoryGirl.create(:event, description: "long" * 50)

      visit admin_event_path(@event)
    end

    it "shows an event" do
      expect(page).to have_content(@event.title)
    end

    it "shows the entire description" do
      # does not truncate
      expect(page).to have_content(@event.description)
    end

    context "with some wishlists" do
      before :each do
        2.times do
          @event.lists << FactoryGirl.create(:list)
        end

        visit admin_event_path(@event)
      end

      it "shows wishlists under an event" do
        @event.lists.each do |wl|
          expect(page).to have_content(wl.title)
        end

        # finds reqquests panel
        expect(page).to have_selector(:xpath, "//div[@class=\"panel\"]/*[text()=\"Wishlists\"]")
      end
    end

    context "with no wishlists" do
      before :each do
        @event.lists.destroy_all

        visit admin_event_path(@event)
      end

      it "does not show the wishlists panel" do
        # finds div.panel with a child node containing the text "Requests"
        expect(page).to have_no_selector(:xpath, "//div[@class=\"panel\"]/*[text()=\"Wishlists\"]")
      end
    end
  end

  describe "#index" do
    before :each do
      @event = FactoryGirl.create(:event)
      @long_desc_event = FactoryGirl.create(:event, description: "long" * 50)

      visit admin_events_path
    end

    it "displays some events" do
      expect(page).to have_content(@event.title)
      expect(page).to have_content(@long_desc_event.title)
    end

    it "truncates long descriptions after 50 characters" do
      expect(page).to have_content(@long_desc_event.description.truncate(50))
    end

    it "lets you create a new event" do
      expect(page).to have_content("New Event")
    end
  end

end
