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
  end
end
