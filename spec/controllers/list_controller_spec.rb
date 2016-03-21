require 'spec_helper'
include AdminSpecHelper

RSpec.describe ListController, type: :controller do

  before(:each) do
    login_as_therapist
    @list = FactoryGirl.create(:list, therapist: @user.role)
  end
  
  describe "POST #create" do
    it "successfully creates a list" do
      post :create, list: {title: "A whole new world", description: "Fantastic description", therapist: @user.role}

      list = JSON.parse(response.body)['list']

      expect(response).to have_http_status(:success)
      expect(list['title']).to eq("A whole new world")
      expect(list['description']).to eq("Fantastic description")
      expect(list['therapist_id']).to eq(@user.role.id)
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
      expect(response).to render_template(:new)
    end
  end

  describe "GET #show" do
    it "returns http success and renders template" do
      get :show, id: @list.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    it "successfully renders the edit view with expected params" do
      get :edit, id: @list.id

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
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

      expect(response).to have_http_status(:success)

      # Test if params were sent through properly
      expect(assigns[:list].title).to eq("The Smith Family")
      expect(assigns[:list].description).to eq("So many Smiths!")

      # Test if ActiveRecord was updated successfully
      expect(@list.title).to eq("The Smith Family")
      expect(@list.description).to eq("So many Smiths!")
    end
  end
end
