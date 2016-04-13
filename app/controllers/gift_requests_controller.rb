class GiftRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user.therapist?
  end
  before_action :require_owned_gift_request!, only: [:edit, :update]

  def new
    @gift_request = GiftRequest.new
    render "gift_request", locals: {list_id: params[:id]}
  end

  def edit
    @gift_request = GiftRequest.find(params[:gift_request_id])
    render "gift_request", locals: {list_id: params[:id]}
  end

  def create
    # params[:id] is the list id this gift request corresponds to
    @gift_request = GiftRequest.new(gift_request_params.merge(list_id: params[:id]))
    if @gift_request.save
      redirect_to wishlist_path(params[:id])
    else
      render "gift_request"
    end
  end

  def update
    @gift_request = GiftRequest.find(params[:id])
    if @gift_request.update_attributes(gift_request_params)
      redirect_to wishlist_path(@gift_request.list.id)
    else
      redirect_to action: "edit", id: @gift_request.id
    end
  end

  def destroy_multiple
    if GiftRequest.destroy(params[:gift_request_ids])
      redirect_to :back
    end
  end

  private

  def gift_request_params
    params.require(:gift_request).permit(:id, :name, :recipient, :description, :link, :gender, :age)
  end

  def require_owned_gift_request!
    gift_id = params[:action] == 'edit' ? params[:gift_request_id].to_i : params[:id].to_i
    redirect_to root_path unless current_user.role.gift_requests.pluck(:id).include?(gift_id)
  end
end
