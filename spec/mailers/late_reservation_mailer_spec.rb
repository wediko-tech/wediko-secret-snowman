require "spec_helper"

RSpec.describe LateReservationMailer do
  describe 'forgot gift' do
    let(:user) { FactoryGirl.create(:donor_user) }
    let(:mail) { LateReservationMailer.forgot_to_buy_gift_email(user) }

      # Test the body of the sent email contains what we expect it to
      it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((mail.from)[0])
    end
      # assert_equal ['friend@example.com'], email.to
      # assert_equal 'You have been invited by me@example.com', email.subject
      # assert_equal read_fixture('invite').join, email.body.to_s

  end
end
