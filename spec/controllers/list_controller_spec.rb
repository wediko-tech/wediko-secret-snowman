require 'spec_helper'
include AdminSpecHelper

RSpec.describe ListController, type: :controller do

  before(:each) do
    login_as_therapist
    @list = FactoryGirl.create(:list, therapist: @user.role)
  end
  
  describe "POST #create" do
    it "successfully creates a list" do
      # Prior to post, there should only be one list in the db
      expect(List.all.length).to eq(1)

      new_list = {title: "A whole new world", description: "Fantastic description", therapist: @user.role}

      post :create, list: new_list

      expect(response).to redirect_to(list_path(assigns(:list).id))

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
      post :create, list: new_list
      expect(assigns(:list).errors.full_messages).to_not be_empty
    end
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "returns http success and renders template" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:wishlist)
    end
  end

  describe "GET #show" do
    it "returns http success and renders template" do
      get :show, id: @list.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end

  describe "DELETE #destroy" do
    it "successfully destroys a list record" do
      delete :destroy, {id: @list.id}

      expect(response).to have_http_status(:no_content)
      expect(List.all.length).to eq(0)
    end
  end

  describe "PUT #update" do
    it "successfully updates a list record" do
      put :update, id: @list.id, list: {title: "The Smith Family", description: "So many Smiths!"}
      @list.reload

      expect(response).to redirect_to(list_index_path)

      # Test if params were sent through properly
      expect(assigns[:list].title).to eq("The Smith Family")
      expect(assigns[:list].description).to eq("So many Smiths!")

      # Test if ActiveRecord was updated successfully
      expect(@list.title).to eq("The Smith Family")
      expect(@list.description).to eq("So many Smiths!")
    end
  end
end