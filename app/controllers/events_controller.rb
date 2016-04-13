class EventsController < ApplicationController
  before_action :authenticate_user!

  # GET /events
  # GET /events.json
  def index
    @events = Event.active
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @lists = @event.lists.owned_by(current_user.role)
    render 'lists/index'
  end
end
