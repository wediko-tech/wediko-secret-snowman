require 'spec_helper'
include AdminSpecHelper

RSpec.describe ListsController, type: :controller do

  before(:each) do
    login_as_therapist
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, therapist: @user.role, event: @event)
  end

  describe "POST #create" do
    it "successfully creates a list" do
      # Prior to post, there should only be one list in the db
      expect(List.all.length).to eq(1)

      new_list = {title: "A whole new world", description: "Fantastic description", therapist: @user.role}

      post :create, event_id: @event.id, list: new_list

      expect(response).to redirect_to(wishlist_path(assigns(:list).id))

      expect(assigns(:list)[:title]).to eq(new_list[:title])
      expect(assigns(:list)[:description]).to eq(new_list[:description])
      expect(assigns(:list)[:therapist_id]).to eq(new_list[:therapist].id)

      # After the post, there should be two
      expect(List.all.length).to eq(2)
      expect(List.last.title).to eq(new_list[:title])
      expect(List.last.description).to eq(new_list[:description])
      expect(List.last.therapist.id).to eq(new_list[:therapist].id)
    end

    it "generates error on invalid creation of list" do
      new_list = {therapist: @user.role}
      post :create, event_id: @event.id, list: new_list
      expect(assigns(:list).errors.full_messages).to_not be_empty
    end

    it "restricts non therapists from doing a create action" do
      login_as_admin
      post :create, event_id: @event.id, list: {title: "Nope"}
      expect(response).to redirect_to(root_path)
      expect(GiftRequest.find_by(name: "Nope")).to be_nil
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "restricts non therapists from doing an index action" do
      login_as_admin
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #new" do
    it "returns http success and renders template" do
      get :new, event_id: @event.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:wishlist)
    end

    it "restricts non therapists from doing a new action" do
      login_as_admin
      get :new, event_id: @event.id
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #show" do
    it "returns http success and renders template" do
      get :show, id: @list.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    it "restricts non therapists from doing a show action" do
      login_as_admin
      get :show, id: @list.id
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE #destroy_multiple" do
    it "successfully destroys a list record" do
      delete :destroy_multiple, {list_ids: [@list.id]}

      expect(List.all.length).to eq(0)
    end

    it "restricts non therapists from doing a delete action" do
      login_as_admin

      delete :destroy_multiple, {list_ids: [@list.id]}

      expect(response).to redirect_to(root_path)
      expect(List.all.length).to eq(1)
    end
  end

  describe "PUT #update" do
    it "successfully updates a list record" do
      put :update, id: @list.id, list: {title: "The Smith Family", description: "So many Smiths!"}
      @list.reload

      expect(response).to redirect_to(wishlists_path)

      # Test if params were sent through properly
      expect(assigns[:list].title).to eq("The Smith Family")
      expect(assigns[:list].description).to eq("So many Smiths!")

      # Test if ActiveRecord was updated successfully
      expect(@list.title).to eq("The Smith Family")
      expect(@list.description).to eq("So many Smiths!")
    end

    it "restricts non therapists from doing an update action" do
      login_as_admin

      put :update, id: @list.id, list: {}

      expect(response).to redirect_to(root_path)
      expect(assigns[:list]).to be_nil
      expect(@list).to eq(@list)
    end
  end
end
