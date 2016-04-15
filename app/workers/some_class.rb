class SomeClass
  include Sidekiq::Worker

  Reservation.reserved.includes(gift_request: {list: :event}).where("events.end_date < ?", Date.current + 7.days)
end
