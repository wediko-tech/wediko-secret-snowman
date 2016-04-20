require 'spec_helper'

  describe LateReservationChecker, inline_jobs: true do
  EXAMPLE_RESERVATION = {
  #   create_table "reservations", force: :cascade do |t|
  #   t.integer  "gift_request_id"
  #   t.integer  "donor_id"
  #   t.string   "tracking_num"
  #   t.boolean  "delinquent",      default: false
  #   t.string   "state"
  #   t.datetime "created_at",                      null: false
  #   t.datetime "updated_at",                      null: false
  # end
    "gift_request_id" => "7357",
    "donor_id" => "1337",
    "tracking_num" => "8675309",
    "delinquent" => "true",
    "state" => "reserved",
    "created_at" => "2010/4/16",
    "updated_at" => "2010/4/16",
  }

  describe "Remind late purchase" do
    #before :each do

    #end
    let(:late)  {FactoryGirl.create(:reservation)}



    it "sends email for late donor" do

      late.delinquent = true

      LateReservationChecker.perform_async#(Date.today)
      last_email = ActionMailer::Base.deliveries.last
      #byebug

      expect(last_email.subject).to include('Thank you for registering')

    end
  end
end
