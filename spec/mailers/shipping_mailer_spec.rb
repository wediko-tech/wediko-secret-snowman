require "spec_helper"
RSpec.describe ShippingMailer do
  describe 'shipped' do
    before :each do
      @user = FactoryGirl.create(:donor_user)
      @mail = ShippingMailer.gift_shipped_email(@user)
    end

      # Test the body of the sent email contains what we expect it to
      it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((@mail.from)[0])
    end
     it 'addresses to proper recipient' do
      expect((@mail.to)[0]).to eql(@user.email)
    end
    it 'renders correct subject' do
        expect(@mail.subject).to eql('Our donor has bought the gift and it is on its way')
    end
    it 'renders correct body' do
      expect(@mail.body).to include("confirmation that your gift is heading on its way")
    end
  end
end
