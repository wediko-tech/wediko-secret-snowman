class ReservationDecorator < Draper::Decorator
  delegate_all

  def polite_status
    object.status == :delinquent ? "delayed" : object.status
  end

  def ship_date
    object.gift_request.list.event.end_date
  end
end
