FactoryGirl.define do
  factory :request do
    sequence(:recipient) { |n| "Recipient #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:link) { |n| "http://fakelink#{n}" }
  end
end