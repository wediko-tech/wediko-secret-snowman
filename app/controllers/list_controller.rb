class ListController < ApplicationController
  def index
    @lists = List.all
  end

  def edit
    @list = List.find(params[:id])
    render "wishlist"
  end

  def new
    @list = List.new
    render "wishlist"
  end

  def show
    @list = List.find(params[:id])
    @requests = @list.gift_requests
  end

  def create
    @list = List.new(list_params.merge(therapist: current_user.role))
    if @list.save
      redirect_to action: "show", id: @list.id
    else
      redirect_to action: "new"
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

  def destroy
    list = List.find(params[:id])
    list.destroy if list
    render nothing: true, status: list.destroyed? ? :no_content : :bad_request
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
end
