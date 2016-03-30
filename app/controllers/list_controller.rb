class ListController < ApplicationController
  def index
    @lists = List.all
  end

  def edit
    @list = List.find(params[:id])
  end

  def new
    @list = List.new
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
      flash[:error] = "A problem occurred while creating the wishlist. Please try again."
      render :new
    end
  end


  def update
    @list = List.find(params[:id])
    render nothing: true, status: @list.update_attributes(list_params) ? :ok : :bad_request
  end

  def destroy
    list = List.find(params[:id])
    list.destroy if list
    render nothing: true, status: list.destroyed? ? :no_content : :bad_request
  end

  private

  def list_params
    params.require(:list).permit(:id, :therapist_id, :title, :description)
  end
end
