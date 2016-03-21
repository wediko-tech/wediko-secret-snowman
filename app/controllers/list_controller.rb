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
    render status: @list ? :ok : :no_content
  end

  def create
    @list = List.new(list_params.merge(therapist: current_user.role))
    status = @list.save ? :ok : :bad_request
    render json: {list: @list}, status: status
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
