require 'spec_helper'
include AdminSpecHelper

RSpec.describe EventsController, type: :controller do

  before(:each) do
    @user = FactoryGirl.create(:therapist_user)
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, therapist: @user.role, event: @event)
  end
  context "as a therapist" do
    before :each do
      login_as_therapist(@user)
    end

    describe "GET #index" do
      context "multiple events" do
        before :each do
          @second_event = FactoryGirl.create(:event)
        end

        it "returns http success and renders the therapist_index template" do
          get :index
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:therapist_index)
        end
      end

      context "one event" do
        it "redirects to the event show page" do
          get :index
          expect(response).to redirect_to(event_url(@event))
        end
      end
    end

    describe "GET #show" do
      it "returns http success and renders the wishlist index template" do
        get :show, id: @event.id
        expect(response).to have_http_status(:success)
        expect(response).to render_template('lists/index')
      end
    end
  end

  context "not logged in" do
    describe "GET #index" do
      context "multiple events" do
        before :each do
          @second_event = FactoryGirl.create(:event)
        end

        it "returns http success and renders the index template" do
          get :index
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
        end
      end

      context "one event" do
        it "redirects to the event catalog page" do
          get :index
          expect(response).to redirect_to(catalog_event_url(@event))
        end
      end
    end
  end
end
