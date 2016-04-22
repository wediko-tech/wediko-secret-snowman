require 'spec_helper'

describe User do
  before :each do
    @therapist = FactoryGirl.create(:therapist_user)
    @donor = FactoryGirl.create(:donor_user)
  end

  it 'has a valid factory' do
    expect(@therapist).to be_valid
    expect(@donor).to be_valid
  end

  it 'should have valid associations for therapist role' do
    expect(@therapist.role_type).to eq("Therapist")
    expect(@therapist.role.class.name).to eq("Therapist")
  end

  it 'should validate phone number for donor role' do
    @donor.phone_number = 'something invalid'
    expect(@donor).not_to be_valid
  end

  it 'should validate address fields for donor role' do
    @donor.address_line_1 = nil
    expect(@donor).not_to be_valid
  end

  it 'should validate address fields for donor role' do
    @donor.address_city = nil
    expect(@donor).not_to be_valid
  end

  it 'should validate address fields for donor role' do
    @donor.address_zip_code = nil
    expect(@donor).not_to be_valid
  end

  it 'should not need valid phone number or address fields for therapist role' do
    @therapist.phone_number = nil
    @therapist.address_line_1 = nil
    @therapist.address_city = nil
    @therapist.address_zip_code = nil
    expect(@therapist).to be_valid
  end

  it 'should have valid associations for donor role' do
    expect(@donor.role_type).to eq("Donor")
    expect(@donor.role.class.name).to eq("Donor")
  end

  it 'sends a registration email' do
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.body).to include("to login with your password at")
  end
end
