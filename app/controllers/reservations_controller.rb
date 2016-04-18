class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_donor


  def ship
    @reservation = Reservation.find(params[:id])

    if @reservation.donor_id == current_user.id
      if @reservation.ship
        render json: @reservation
      else
        render status: 500, json: { errors: @reservation.errors.full_messages }
      end

    else
      redirect_to root_path, alert: "You are not authorized to access that page."
    end
  end

  def destroy

    @reservation = Reservation.find(params[:id])

    if @reservation.state == 'received'
      redirect_to :back, alert: "This gift has been marked as received and can't be cancelled."
    end

    if @reservation.donor_id == current_user.id
      @reservation.destroy!
      redirect_to :back
    else
      redirect_to root_path, alert: "You are not authorized to access that page."
    end
  end


  private

  def require_donor
    if current_user
      unless current_user.try(:donor?)
        redirect_to root_path, alert: "You are not authorized to access that page."
      end
    else
      redirect_to login_path, alert: "You are not authorized to access that page."
    end
  end

end