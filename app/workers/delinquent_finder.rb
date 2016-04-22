class DelinquentFinder
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    late_unmarked_reservations = Reservation.joins(gift_request: {list: :event}).includes(donor: :user).unreceived
                                   .where("events.end_date <= ?", Date.today)
                                   .where(delinquent: false)
    late_users = late_unmarked_reservations.map(&:donor).map(&:user).uniq
    late_unmarked_reservations.update_all(delinquent: true)

    late_users.each{|user| LateReservationMailer.delinquent_reservation(user).deliver_now }
  end
end
