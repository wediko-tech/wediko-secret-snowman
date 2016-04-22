require 'spec_helper'

describe LateReservationChecker, inline_jobs: true do
  describe "Remind late purchase" do
    before :each do
      @donor = FactoryGirl.create(:donor_user)
      @late = FactoryGirl.create(:late_reservation)
      @other = FactoryGirl.create(:reservation)
    end

    it "sends email for late donor" do
      LateReservationChecker.perform_async
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.subject).to include('Please check your gift reservations!')
    end
  end
end

