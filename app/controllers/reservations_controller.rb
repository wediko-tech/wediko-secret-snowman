class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_donor
  before_action :find_reservation, only: [:mark_shipped, :ship, :cancel, :destroy]
  before_action :require_owned_reservation, only: [:ship, :cancel, :destroy]

  def index
    @back_route = root_path
    @reservations = current_user.role.reservations.notable.order(delinquent: :desc).decorate
  end

  def mark_shipped
    @back_route = reservations_path
  end

  # this moves the reservation from reserved to shipped
  def ship
    if @reservation.update(ship_params) && @reservation.ship
      redirect_to reservations_path, notice: "Reservation shipped."
    else
      render :mark_shipped, alert: @reservation.errors
    end
  end

  # this moves the reservation from shipped to reserved
  def cancel
    if @reservation.can_cancel?
      @reservation.cancel!
      redirect_to reservations_path, notice: "Shipment cancelled."
    else
      redirect_to reservations_path, alert: "That gift is marked as #{@reservation.state} and cannot have its shipment cancelled."
    end
  end

  def destroy
    if @reservation.state == 'received'
      redirect_to reservations_path, alert: "This gift has been marked as received and can't be cancelled."
    else
      @reservation.destroy!
      redirect_to reservations_path, notice: "Reservation cancelled."
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

  def require_owned_reservation
    unless @reservation.donor_id == current_user.role.id
      redirect_to root_path, alert: "You are not authorized to access that page."
    end
  end

  def ship_params
    params.require(:reservation).permit(:tracking_number, :shipment_method)
  end

  def find_reservation
    @reservation = Reservation.find(params[:id])
  end
end
