require 'rails_helper'

describe List do
  before(:each) do
    @therapist = FactoryGirl.create(:therapist_user)
    @list = FactoryGirl.create(:list, therapist: @therapist.role)
    @request = FactoryGirl.create(:request, list: @list)
  end

  it 'has a valid factory' do
    expect(@list).to be_valid
  end

  it 'should be properly associated with a therapist' do
    expect(@list.therapist).to eq(@therapist.role)
    expect(@therapist.role.lists.last).to eq(@list)
    expect(@therapist.role.lists.length).to eq(1)
  end

  it 'can have multiple lists under therapist role' do
    list2 = FactoryGirl.create(:list, therapist: @therapist.role)
    expect(@therapist.role.lists.length).to eq(2)
  end

  it 'properly associates with a request' do
    expect(@list.requests.last).to eq(@request)
  end
end
