FactoryGirl.define do
  factory :gift_request do
    list
    sequence(:name) { |n| "Pretty Toy #{n}" }
    sequence(:recipient) { |n| "Recipient #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:link) { |n| "http://fakelink#{n}" }
    sequence(:age, 5)
    gender "Male"


    factory :reserved_gift_request do
      # [Steve] Just calling "reservation" here creates an extra orphaned gift request for some reason
      after :build do |gr|
        gr.reservation ||= FactoryGirl.create(:reservation, gift_request: gr)
      end
    end
  end
end
