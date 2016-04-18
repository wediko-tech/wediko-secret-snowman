class GiftRequestsController < ApplicationController
  before_action :authenticate_user!, except: :catalog
  before_action :require_therapist, except: [:catalog, :reserve]
  before_action :require_donor, only: :reserve
  before_action :require_owned_gift_request!, only: [:edit, :update]
  before_action :find_gift_request, only: [:edit, :update]

  def new
    @back_route = wishlist_path(params[:id])

    @gift_request = GiftRequest.new
    render "gift_request", locals: {list_id: params[:id]}
  end

  def edit
    @back_route = wishlist_path(params[:id])

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

  def catalog
    @back_route = events_path

    @event = Event.find(params[:id])
    @gift_requests = @event.gift_requests.unreserved.order(created_at: :asc).page(params[:page] || 1)
  end

  def reserve
    @gift_request = GiftRequest.find(params[:id])
    reservation = Reservation.new(gift_request_id: params[:id], donor_id: current_user.role.id)
    if reservation.save
      redirect_to catalog_event_path(id: @gift_request.list.event_id), alert: "Your reservation has been saved!"
    else
      redirect_to catalog_event_path(id: @gift_request.list.event_id), alert: "There was an error reserving that gift."
    end
  end


  private

  def gift_request_params
    params.require(:gift_request).permit(:id, :name, :recipient, :description, :link, :gender, :age)
  end

  def require_therapist
    if current_user
      unless current_user.try(:therapist?)
        redirect_to root_path, alert: "You are not authorized to access that page."
      end
    else
      redirect_to login_path, alert: "You are not authorized to access that page."
    end
  end

  def require_donor
    if current_user
      unless current_user.try(:donor?)
        redirect_to root_path, alert: "You are not authorized to access that page."
      end
    else
      redirect_to login_path, alert: "You are not authorized to access that page."
    end
  end

  def require_owned_gift_request!
    gift_id = params[:action] == 'edit' ? params[:gift_request_id].to_i : params[:id].to_i
    redirect_to root_path unless current_user.role.gift_requests.pluck(:id).include?(gift_id)
  end

  def find_gift_request
    @gift_request = GiftRequest.find(params[:gift_request_id] || params[:id])
  end
end
