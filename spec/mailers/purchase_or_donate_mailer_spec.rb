require 'spec_helper'
RSpec.describe PurchaseOrDonateMailer do
  describe 'donate' do
    let(:user) { FactoryGirl.create(:donor_user) }
    let(:mail) { PurchaseOrDonateMailer.please_give_email(user) }

    it 'renders the sender email' do
      expect(ApplicationMailer.default[:from]).to eql((mail.from)[0])
    end
    it 'addresses to proper recipient' do
      expect((mail.to)[0]).to eql(user.email)
    end
    it 'renders correct subject' do
        expect(mail.subject).to eql("Your help is essential!")
    end
    it 'renders correct body' do
      expect(mail.body).to include("Every little bit counts, and your help is instrumental to our success")
    end
  end
end
