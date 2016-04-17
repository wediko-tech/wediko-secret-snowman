class GiftRequestsController < ApplicationController
  before_action :authenticate_user!, except: :catalog
  before_action :require_therapist, except: :catalog
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
    @gift_requests = @event.gift_requests.unreserved.order(created_at: :asc)
    if params[:gender] && ["M", "F"].include?(params[:gender])
      @gift_requests = @gift_requests.where(gender: params[:gender])
    end

    if params.slice(:min_age, :max_age).any?
      @gift_requests = @gift_requests.where("age BETWEEN ? AND ?",
        params[:min_age].present? ? params[:min_age] : 0,
        params[:max_age].present? ? params[:max_age] : 200)
    end

    @gift_requests = @gift_requests.page(params[:page] || 1)
  end

  def fetch_amazon_info
    valid_amazon_link = AmazonProductApi.amazon_link?(params[:link])
    if valid_amazon_link
      asin = AmazonProductApi.asin_from_url(params[:link])
      item_info = AmazonProductApi.item_search(asin)["ItemAttributes"]
      render json: {
        valid_amazon_link: valid_amazon_link,
        item_info: item_info,
        asin: asin,
        associate_tag: Rails.configuration.amazon_associate_tag
      }
    else
      render nothing: true, status: 404
    end
  end

  private

  def search_filters?
    params.slice(:gender, :min_age, :max_age).any?
  end
  helper_method :search_filters?

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

  def require_owned_gift_request!
    gift_id = params[:action] == 'edit' ? params[:gift_request_id].to_i : params[:id].to_i
    redirect_to root_path unless current_user.role.gift_requests.pluck(:id).include?(gift_id)
  end

  def find_gift_request
    @gift_request = GiftRequest.find(params[:gift_request_id] || params[:id])
  end
end
