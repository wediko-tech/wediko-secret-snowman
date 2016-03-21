class ListController < ApplicationController
  def index
    @lists = List.all
  end

  def edit
    @list = List.find_by_id(params[:id])
  end

  def new
    @list = List.new
  end

  def show
    @list = List.find_by_id(params[:id])
  end

  def create
    @list = List.new(list_params.merge(therapist: current_user.role))
    if @list.save
      render json: {list: @list}, status: :ok
    else
      render json: {errors: @list.errors.full_messages}, status: :bad_request
    end
  end

  def update
    @list = List.find_by_id(params[:id])
    render nothing: true, status: @list.update_attributes(list_params) ? :ok : :bad_request
  end

  def destroy
    list = List.find_by_id(params[:id])
    list.destroy if list
    render nothing: true, status: list.destroyed? ? :no_content : :bad_request
  end

  private

  def list_params
    params.require(:list).permit(:id, :therapist_id, :title, :description)
  end
end
