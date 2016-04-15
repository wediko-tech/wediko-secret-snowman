class ReservationsController < ApplicationController
  before_action :authenticate_user!


  def new
    @reservation = Reservation.new
    render "reservation", locals: {list_id: params[:id]}
  end

  # aka "create" method
  def reserve
    @reservation = Reservation.new(reservation_params)
    @reservation.reserve
    if @reservation.save
      redirect_to  #TODO: somewhere? #wishlist_path(params[:id])
    else
      render "reservation"
    end
  end

  # aka "update" method (there's two)
  def ship
    @reservation = Reservation.find(params[:id])

    if @reservation.donor_id == current_user.id || current_user.administrator?
      @reservation.ship
      redirect_to #TODO wherever?
    else
      # TODO
      render status: :unauthorized
    end
  end

  # aka other update method
  def receive
    @reservation = Reservation.find(params[:id])

    # not sure if only admins should be able to mark something received?
    if current_user.administrator?
      @reservation.receive
      redirect_to #TODO wherever?
    else
      # TODO
      render status: :unauthorized
    end
  end


  def delete
    @reservation = Reservation.find(params[:id])

    if @reservation.donor_id == current_user.id || current_user.administrator?
      @reservation.cancel
      redirect_to #TODO wherever?
    else
      # TODO
      render status: :unauthorized
    end
  end



  private

  def reservation_params
    params.require(:reservation).permit(:gift_request_id, :donor_id)
  end

end