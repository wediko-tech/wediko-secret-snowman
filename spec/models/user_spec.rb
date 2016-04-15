require 'spec_helper'

describe User do
  around(:each)do
   |example| ActionMailer::Base.deliveries.clear
    example.run
    ActionMailer::Base.deliveries.clear
 end

  let(:therapist) { FactoryGirl.create(:therapist_user) }
  let(:donor) { FactoryGirl.create(:donor_user) }

   # it 'sends registration email on create' do
   #   ActionMailer::Base.deliveries = []
   #   ActionMailer::Base.deliveries.clear
   #   expect{FactoryGirl.create(:donor_user)}.to change { ActionMailer::Base.deliveries.count }.by(1)

#       last_email = ActionMailer::Base.deliveries.last
# expect(last_email.to).to eq ['test@example.com']
# expect(last_email.subject).to have_content 'Welcome'
    # ActionMailer::Base.deliveries = []
   #end

  it 'has a valid factory' do
    expect(therapist).to be_valid
    expect(donor).to be_valid
  end

  it 'should have valid associations for therapist role' do
    expect(therapist.role_type).to eq("Therapist")
    expect(therapist.role.class.name).to eq("Therapist")
  end

  it 'should have valid associations for donor role' do
    expect(donor.role_type).to eq("Donor")
    expect(donor.role.class.name).to eq("Donor")
  end

  it 'sends an email' do
   # ActionMailer::Base.deliveries.clear
    donor.send(:send_registered_email)
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.body).to include("to login with your password at")
      #ActionMailer::Base.deliveries.clear
  end
end
