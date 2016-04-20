require 'spec_helper'

  describe LateReservationChecker, inline_jobs: true do

    describe "Remind late purchase" do
      before :each do
        @donor = FactoryGirl.create(:donor_user)
        @late = FactoryGirl.create(:reservation, delinquent: true, created_at: "2015-12-05 15:53:40")
        @other = FactoryGirl.create(:reservation)
      end




    it "sends email for late donor" do

      Reservation.reserved[0].delinquent = true

      LateReservationChecker.perform_async()#(Date.today)
      last_email = ActionMailer::Base.deliveries.last
      #byebug
      #Please check your gift reservations!
      #Thank you for registering
      expect(last_email.subject).to include('Please check your gift reservations!')

    end
  end
end

