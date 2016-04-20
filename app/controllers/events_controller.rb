class EventsController < ApplicationController
  # GET /events
  def index
    @events = Event.active.decorate

    if current_user.try(:therapist?)
      render 'therapist_index'
    else
      render 'index'
    end
  end

  # GET /events/1
  def show
    @back_route = events_path
    @event = Event.find(params[:id])
    @lists = @event.lists.owned_by(current_user.role)
    render 'lists/index'
  end
end
