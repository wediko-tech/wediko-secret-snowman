FactoryGirl.define do
  factory :list do
    sequence(:description) { |n| "Description #{n}" }
    sequence(:title) { |n| "Title #{n}" }
  end
end