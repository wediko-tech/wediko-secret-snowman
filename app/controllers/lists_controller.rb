class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action do
    redirect_to root_path unless current_user.therapist?
  end
  before_action :require_owned_wishlist!, only: [:edit, :show, :update]

  def index
    @back_route = events_path

    @lists = current_user.role.lists
  end

  def edit
    @back_route = wishlist_path(params[:id])
    @list = List.find(params[:id])
    
    render "wishlist"
  end

  def new
    @back_route = event_path(params[:event_id])
    @list = List.new

    render "wishlist"
  end

  def show
    @list = List.find(params[:id])
    @back_route = event_path(@list.event_id)
    @gift_requests = @list.gift_requests
  end

  def create
    @list = List.new(list_params.merge(therapist: current_user.role, event: Event.find(params[:event_id])))
    if @list.save
      redirect_to action: "show", id: @list.id
    else
      render "wishlist"
    end
  end


  def update
    @list = List.find(params[:id])
    if @list.update_attributes(list_params)
      redirect_to action: "index"
    else
      redirect_to action: "edit", id: @list.id
    end
  end

  def destroy_multiple
    if List.destroy(params[:list_ids])
      redirect_to action: "index"
    end
  end

  private

  def list_params
    params.require(:list).permit(:id, :therapist_id, :title, :description)
  end

  def require_owned_wishlist!
    redirect_to root_path unless current_user.role.lists.pluck(:id).include?(params[:id].to_i)
  end
end
