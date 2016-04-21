require "spec_helper"
RSpec.describe RegistrationMailer do
  describe 'notified registration' do
    before :each do
      @user = FactoryGirl.create(:donor_user)
      @mail = RegistrationMailer.registration_email(@user).deliver_now
    end

      # Test the body of the sent email contains what we expect it to
    it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((@mail.from)[0])
    end
    it 'addresses to proper recipient' do
      expect((@mail.to)[0]).to eql(@user.email)
    end
    it 'renders correct subject' do
        expect(@mail.subject).to eql(Rails.configuration.registration_mailer_subject)
    end
    it 'renders correct body' do
      expect(@mail.body).to include("to login with your password at")
    end
    it 'renders users name properly' do
      expect(@mail.body.encoded).to include(@user.name)
    end
    it 'renders users email properly' do
      expect(@mail.body.encoded).to include(@user.email)
    end
  end
end
