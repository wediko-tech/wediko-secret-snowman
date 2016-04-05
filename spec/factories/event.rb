FactoryGirl.define do
  factory :event do
    sequence(:title) { |n| "Event Title #{n}" }
    sequence(:description) { |n| "Event Description #{n}" }
    start_date Time.now
    end_date { 7.days.from_now }

  end
end
