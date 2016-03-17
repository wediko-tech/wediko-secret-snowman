require 'spec_helper'

describe Request do
  before(:each) do
    @therapist = FactoryGirl.create(:therapist_user)
    @lists = FactoryGirl.create_list(:list, 2, therapist: @therapist.role)
    @request = FactoryGirl.create(:request, list: @lists.first)
  end

  it 'has a valid factory' do
    expect(@request).to be_valid
  end

  it 'properly associates with a list' do
    expect(@request.list).to eq(@lists.first)
  end
end
