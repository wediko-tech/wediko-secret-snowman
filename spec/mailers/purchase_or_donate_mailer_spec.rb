

#https://stackoverflow.com/questions/19983221/actionmailer-testing-with-rspec
require 'spec_helper'

RSpec.describe PurchaseOrDonateMailer do
  describe 'donate' do
    let(:user) { FactoryGirl.create(:donor_user) }
    let(:mail) { PurchaseOrDonateMailer.please_give_email(user) }

    it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((mail.from)[0])
    end

    # it 'renders the receiver email' do
    #   expect(mail.to).to eql([user.email])
    # end

    # it 'renders the sender email' do
    #   expect(mail.from).to eql(['noreply@company.com'])
    # end

    # it 'assigns @name' do
    #   expect(mail.body.encoded).to match(user.name)
    # end

    # it 'assigns @confirmation_url' do
    #   expect(mail.body.encoded).to match("http://aplication_url/#{user.id}/confirmation")
    # end
  end
end
