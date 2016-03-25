require 'spec_helper'

describe GiftRequest do
  before :each do
    @gift_request = FactoryGirl.create(:gift_request)
  end

  it 'has a valid factory' do
    expect(@gift_request).to be_valid
  end

  it 'properly associates with a list' do
    expect(@gift_request.list.class).to eq List
  end

  it "includes only reserved requests in its reserved scope" do
    reserved = FactoryGirl.create(:reserved_gift_request)
    expect(GiftRequest.reserved).to match_array([reserved])
  end

  it "includes only unreserved requests in its unreserved scope" do
    reserved = FactoryGirl.create(:reserved_gift_request)
    expect(GiftRequest.unreserved).to match_array([@gift_request])
  end
end
