require 'spec_helper'

describe List do
  before(:each) do
    @therapist = FactoryGirl.create(:therapist_user)
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, therapist: @therapist.role, event: @event)
    @gift_request = FactoryGirl.create(:gift_request, list: @list)
  end

  it 'has a valid factory' do
    expect(@list).to be_valid
  end
  it 'sends an email on creation' do
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to include("Congratulations for creating a wishlist!")
  end

  it 'should be properly associated with a therapist' do
    expect(@list.therapist).to eq(@therapist.role)
    expect(@therapist.role.lists.last).to eq(@list)
    expect(@therapist.role.lists.length).to eq(1)
  end

  it 'should be properly associated with an event' do
    expect(@list.event).to eq(@event)
    expect(@event.lists).to match_array([@list])
    expect(@event.lists.length).to eq(1)
  end

  it 'can have multiple lists under therapist role' do
    list2 = FactoryGirl.create(:list, therapist: @therapist.role, event: @event)
    expect(@therapist.role.lists.length).to eq(2)
  end

  it 'can have multiple lists under event' do
    list2 = FactoryGirl.create(:list, therapist: @therapist.role, event: @event)
    @event.reload
    expect(@event.lists.length).to eq(2)
  end

  it 'properly associates with a gift request' do
    expect(@list.gift_requests.last).to eq(@gift_request)
  end

  it "should only show empty lists in its empty scope" do
    empty_list = FactoryGirl.create(:list)
    expect(List.empty).to match_array([empty_list])
  end

  it "should only show non-empty lists in its non-empty scope" do
    empty_list = FactoryGirl.create(:list)
    expect(List.non_empty).to match_array([@list])
  end

end
