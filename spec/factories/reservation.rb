FactoryGirl.define do
  factory :reservation do
    delinquent false

    gift_request
    donor
  end
end
