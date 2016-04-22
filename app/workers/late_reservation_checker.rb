class LateReservationChecker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    late_reservations = Reservation.reserved.joins(gift_request: {list: :event}).where("events.end_date < ? AND delinquent IS FALSE", Date.current + 7.days)
    delinquent_donors = Hash.new{0}
    #for each loop, going through all reservations looking for common donors
    late_reservations.each do |reservation|
      delinquent_donors[reservation.donor] += 1

    end
    delinquent_donors.each do |donor, delinquencies|
      #insert how many gifts they forgot to send
      #If you have time, add recipient and what the gift was
      LateReservationMailer.forgot_to_buy_gift_email(donor.user, delinquencies).deliver_now
    end
  end

end
