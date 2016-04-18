require 'spec_helper'
include AdminSpecHelper
include LoginHelper

RSpec.describe GiftRequestsController, type: :controller do

  before(:each) do
    login_as_therapist
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, event: @event, therapist: @user.role)
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

      expect(response).to redirect_to(wishlist_path(@list.id))

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


    it "restricts non therapists from doing a create action" do
      login_as_admin

      post :create, gift_request: {name: "Nope"}, id: @list.id
      expect(response).to redirect_to(root_path)
      expect(GiftRequest.find_by(name: "Nope")).to be_nil
    end
  end

  describe "GET #new" do
    it "returns http success and renders template" do
      get :new, id: @event.id
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:gift_request)
    end

    it "restricts non therapists from doing a new action" do
      login_as_admin
      get :new, id: @event.id
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE #destroy_multiple" do
    it "successfully destroys a gift request record" do
      request.env["HTTP_REFERER"] = "/wishlists/#{@list.id}"
      delete :destroy_multiple, {gift_request_ids: [@gift_requests[0].id]}

      expect(GiftRequest.all.length).to eq(@gift_requests.length - 1)
    end

    it "successfully destroys multiple gift request records" do
      request.env["HTTP_REFERER"] = "/wishlists/#{@list.id}"
      delete :destroy_multiple, {gift_request_ids: @gift_requests.map { |gr| gr.id }}

      expect(GiftRequest.all.length).to eq(0)
    end

    it "restricts non therapists from doing a delete action" do
      login_as_admin

      delete :destroy_multiple, {gift_request_ids: @gift_requests.map { |gr| gr.id }}

      expect(response).to redirect_to(root_path)
      expect(GiftRequest.all.length).to eq(@gift_requests.length)
    end
  end

  describe "PUT #update" do
    it "successfully updates a gift request record" do
      updated_gift_request = {name: "Updated name", description: "Updated description"}
      put :update, id: @gift_requests.first.id, gift_request: updated_gift_request

      @gift_requests.first.reload

      expect(response).to redirect_to(wishlist_path(@list.id))

      # Test if params were sent through properly
      expect(assigns[:gift_request].name).to eq(updated_gift_request[:name])
      expect(assigns[:gift_request].description).to eq(updated_gift_request[:description])

      # Test if ActiveRecord was updated successfully
      expect(@gift_requests.first.name).to eq(updated_gift_request[:name])
      expect(@gift_requests.first.description).to eq(updated_gift_request[:description])
    end

    it "restricts non therapists from doing an update action" do
      login_as_admin
      put :update, id: @gift_requests.first.id, gift_request: {name: "Nope"}

      expect(response).to redirect_to(root_path)
      expect(GiftRequest.find_by(name: "Nope")).to be_nil
    end
  end

  describe "POST #reserve" do
    it "successfully creates a reservation for a gift request" do
      login_as_donor

      post :reserve, id: @gift_requests[0].id

      expect(response).to redirect_to(catalog_event_path(@gift_requests[0].list.event_id))


      expect(Reservation.all.length).to eq(1)
      expect(Reservation.last.state).to eq('reserved')
      expect(Reservation.last.donor_id).to eq(@user.role.id)
      expect(Reservation.last.gift_request_id).to eq(@gift_requests[0].id)
    end
  end

end
