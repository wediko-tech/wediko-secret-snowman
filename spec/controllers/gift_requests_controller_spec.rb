require 'spec_helper'
include AdminSpecHelper

RSpec.describe GiftRequestsController, type: :controller do

  before(:each) do
    login_as_therapist
    @list = FactoryGirl.create(:list, therapist: @user.role)
    @gift_requests = FactoryGirl.create_list(:gift_request, 3, list_id: @list.id)
  end
  
  describe "POST #create" do
    it "successfully creates a gift request for a list" do
      new_gift_request = {
        name: "Monopoly", 
        recipient: "Jenny", 
        description: "Jenny loves board games", 
        gender: "F", 
        age: 8
      }

      post :create, gift_request: new_gift_request, id: @list.id

      expect(response).to redirect_to(list_path(@list.id))

      expect(assigns(:gift_request)[:name]).to eq(new_gift_request[:name])
      expect(assigns(:gift_request)[:recipient]).to eq(new_gift_request[:recipient])
      expect(assigns(:gift_request)[:description]).to eq(new_gift_request[:description])
      expect(assigns(:gift_request)[:gender]).to eq(new_gift_request[:gender])
      expect(assigns(:gift_request)[:age]).to eq(new_gift_request[:age])

      # After the post, there should be two in db
      expect(GiftRequest.all.length).to eq(4)
      expect(GiftRequest.last.name).to eq(new_gift_request[:name])
      expect(GiftRequest.last.description).to eq(new_gift_request[:description])
      expect(GiftRequest.last.recipient).to eq(new_gift_request[:recipient])
      expect(GiftRequest.last.gender).to eq(new_gift_request[:gender])
      expect(GiftRequest.last.age).to eq(new_gift_request[:age])
      expect(GiftRequest.last.list.id).to eq(@list.id)
    end

    it "generates error on invalid creation of gift request" do
      invalid_gift_request = {name: "Wow this is like, so invalid"}

      post :create, gift_request: invalid_gift_request, id: @list.id

      expect(assigns(:gift_request).errors.full_messages).to_not be_empty
    end
  end

  describe "GET #new" do
    it "returns http success and renders template" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:gift_request)
    end
  end

  describe "DELETE #destroy_multiple" do
    it "successfully destroys a gift request record" do
      request.env["HTTP_REFERER"] = "/list/#{@list.id}"
      delete :destroy_multiple, {gift_request_ids: [@gift_requests[0].id]}

      expect(GiftRequest.all.length).to eq(@gift_requests.length - 1)
    end

    it "successfully destroys multiple gift request records" do
      request.env["HTTP_REFERER"] = "/list/#{@list.id}"
      delete :destroy_multiple, {gift_request_ids: @gift_requests.map { |gr| gr.id }}

      expect(GiftRequest.all.length).to eq(0)
    end
  end

  describe "PUT #update" do
    it "successfully updates a gift request record" do
      updated_gift_request = {name: "Updated name", description: "Updated description"}
      put :update, id: @gift_requests.first.id, gift_request: updated_gift_request

      @gift_requests.first.reload

      expect(response).to redirect_to(list_path(@list.id))

      # Test if params were sent through properly
      expect(assigns[:gift_request].name).to eq(updated_gift_request[:name])
      expect(assigns[:gift_request].description).to eq(updated_gift_request[:description])

      # Test if ActiveRecord was updated successfully
      expect(@gift_requests.first.name).to eq(updated_gift_request[:name])
      expect(@gift_requests.first.description).to eq(updated_gift_request[:description])
    end
  end
end
