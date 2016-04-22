FactoryGirl.define do
  factory :user do
    sequence(:email, 1000){|i| "some_person_#{i}@email.biz"}
    name "Decker"
    password "buttscarlton"
    password_confirmation "buttscarlton"
    phone_number '617-111-1111'
    address_line_1 '123 main'
    address_city 'boston'
    address_zip_code '02110'

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
