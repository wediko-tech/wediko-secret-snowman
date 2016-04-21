require 'spec_helper'

describe User do
  let(:therapist) { FactoryGirl.create(:therapist_user) }
  let(:donor) { FactoryGirl.create(:donor_user) }

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

  it 'sends a registration email' do
    FactoryGirl.create(:donor_user)
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.body).to include("to login with your password at")
  end
end
