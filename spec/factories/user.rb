FactoryGirl.define do
  factory :user do
    sequence(:email, 1000){|i| "some_person_#{i}@email.biz"}
    password "buttscarlton"
    password_confirmation "buttscarlton"

    factory :therapist_user, class: "User" do
      association :role, factory: :therapist
    end

    factory :donor_user, class: "User" do
      association :role, factory: :donor
    end

    factory :admin_user, class: "User" do
      association :role, factory: :administrator
    end
  end
end
