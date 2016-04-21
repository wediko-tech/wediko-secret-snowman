require "spec_helper"
RSpec.describe WishlistMailer do
  describe 'wishlist created' do
    let(:therapist) { FactoryGirl.create(:therapist_user) }
    let(:mail) { WishlistMailer.wish_list_creation_email(therapist) }

    it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((mail.from)[0])
    end
    it 'addresses to proper recipient' do
      expect((mail.to)[0]).to eql(therapist.email)
    end
    it 'renders correct subject' do
      expect(mail.subject).to eql(Rails.configuration.wish_list_creation_email_subject)
    end
    it 'renders correct body' do
      expect(mail.body).to include("was successfully created. You can now add gifts for donors ")
    end
  end

  describe 'purchase from wishlist' do
    let(:user) { FactoryGirl.create(:donor_user) }
    let(:mail) { WishlistMailer.item_purchased_email(user) }

    it 'renders the sender' do
      expect(ApplicationMailer.default[:from]).to eql((mail.from)[0])
    end
    it 'addresses to proper recipient' do
      expect((mail.to)[0]).to eql(user.email)
    end
    it 'renders correct subject' do
      expect(mail.subject).to eql(Rails.configuration.item_purchased_email_subject)
    end
    it 'renders correct body' do
      expect(mail.body).to include("purchase was successful. You will shortly")
    end
  end
end

