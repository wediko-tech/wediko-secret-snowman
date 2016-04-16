class ReservationsController < ApplicationController
  before_action :authenticate_user!


  def new
    @reservation = Reservation.new
    render "reservation", locals: {list_id: params[:id]}
  end

  # aka "update" method (there's two)
  def ship
    @reservation = Reservation.find(params[:id])

    if @reservation.donor_id == current_user.id || current_user.administrator?
      @reservation.ship
      @reservation.save
      # TODO obviously not
      redirect_to login_path
    else
      # TODO
      redirect_to root_path, alert: "You are not authorized to access that page."
    end
  end

  # aka other update method
  def receive
    @reservation = Reservation.find(params[:id])

    # not sure if only admins should be able to mark something received?
    if current_user.administrator?
      @reservation.receive
      # TODO obviously not
      redirect_to login_path
    else
      # TODO
      redirect_to root_path, alert: "You are not authorized to access that page."
    end
  end


  def destroy
    @reservation = Reservation.find(params[:id])

    if @reservation.donor_id == current_user.id || current_user.administrator?
      @reservation.cancel
      # TODO obviously not
      redirect_to login_path
    else
      # TODO
      redirect_to root_path, alert: "You are not authorized to access that page."
    end
  end

end