FactoryGirl.define do
  factory :therapist_user, class: "User" do
    association :role, factory: :therapist
  end

  factory :donor_user, class: "User" do
    association :role, factory: :donor
  end

  factory :therapist do
  end

  factory :donor do
  end
end