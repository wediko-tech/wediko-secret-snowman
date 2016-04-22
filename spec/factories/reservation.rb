FactoryGirl.define do
  factory :reservation do
    delinquent false

    gift_request
    donor

    factory :shipped_reservation do
      state 'shipped'
      tracking_number "123456a"
      shipment_method "carrier pigeon"
    end

    factory :late_reservation do
      after(:create) do |reservation, evaluator|
        reservation.gift_request.list.event.update_attributes(start_date: 2.weeks.ago, end_date: 2.days.ago)
      end

      factory :delinquent_reservation do
        delinquent true
      end
    end
  end
end
