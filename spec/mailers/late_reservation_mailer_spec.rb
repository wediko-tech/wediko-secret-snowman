require "spec_helper"

RSpec.describe LateReservationMailer do
  describe 'forgot gift' do
    before :each do
      @user = FactoryGirl.create(:donor_user)
      @delinquencies = 3
      @mail = LateReservationMailer.forgot_to_buy_gift_email(@user.id, @delinquencies).deliver_now
    end

    # Test sender and make sure it comes from the correct address
    it 'renders the sender' do
      expect((@mail.from)[0]).to eql(ApplicationMailer.default[:from])
    end
    #Test recipient and make sure it is being sent to the user's email
    it 'addresses to proper recipient' do
      expect((@mail.to)[0]).to eql(@user.email)
    end
    #Test the subject and make sure it is displaying correctly
    it 'renders correct subject' do
        expect(@mail.subject).to eql('Please check your gift reservations!')
    end
    #Test an element of the body and make sur it is correct
    it 'renders correct body' do
      expect(@mail.body).to include("The deadline for these gifts")
      @delinquencies = 1
      @mail = LateReservationMailer.forgot_to_buy_gift_email(@user, @delinquencies).deliver_now
      expect(@mail.body).to include("gift")
      expect(@mail.body).to include("gifts")
    end
    it 'renders users name properly' do
      expect(@mail.body.encoded).to include("3")
      expect(@mail.body.encoded).to include(@user.name)
    end
  end
end
