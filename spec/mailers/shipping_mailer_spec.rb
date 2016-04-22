require "spec_helper"
RSpec.describe ShippingMailer do
  describe 'shipped' do
    before :each do
      @reservation = FactoryGirl.create(:reservation)
      @mail = ShippingMailer.gift_shipped_email(@reservation.id)
    end

      # Test the body of the sent email contains what we expect it to
      it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((@mail.from)[0])
    end
     it 'addresses to proper recipient' do
      expect((@mail.to)[0]).to eql(Rails.configuration.wediko_notification_address)
    end
    it 'renders correct subject' do
        expect(@mail.subject).to eql('A gift has been shipped.')
    end
    it 'renders correct body' do
      expect(@mail.body).to include("confirmation that a gift has been shipped")
    end
  end
end
