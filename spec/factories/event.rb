FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "Event Title #{n}" }
    sequence(:description) { |n| "Event Description #{n}" }
    start_date Time.now
    end_date { 7.days.from_now }

    address_line_1 "123 Broad Street"
    address_line_2 "Unit 2"
    address_city "Boston"
    address_state "MA"
    address_zip_code "02110"
  end
end
