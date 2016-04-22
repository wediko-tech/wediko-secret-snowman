require 'spec_helper'

describe DelinquentFinder, inline_jobs: true do
  describe "#perform" do
    before :each do
      @late_donor = FactoryGirl.create(:donor_user)
      @safe_donor = FactoryGirl.create(:donor_user)

      # makes a reservation that should be delinquent but isn't yet
      @late = FactoryGirl.create(:delinquent_reservation, donor: @late_donor.role, delinquent: false)
      @other = FactoryGirl.create(:reservation, donor: @safe_donor.role)
    end

    it "sends only donors with overdue reservations an email" do
      expect { DelinquentFinder.perform_async }.to change{ActionMailer::Base.deliveries.length}.by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to include('past due')
    end

    it "sends only one email per donor" do
      another_late = FactoryGirl.create(:delinquent_reservation, donor: @late_donor.role)

      expect { DelinquentFinder.perform_async }.to change{ActionMailer::Base.deliveries.length}.by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to include('past due')
    end
  end
end

