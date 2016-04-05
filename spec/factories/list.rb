FactoryGirl.define do
  factory :list do
    therapist
    event
    sequence(:description) { |n| "Description #{n}" }
    sequence(:title) { |n| "Title #{n}" }

    trait :with_requests do
      transient do
        requests_count 3
      end

      after :create do |list, ev|
        create_list(:gift_request, ev.requests_count, list: list)
      end
    end
  end
end
