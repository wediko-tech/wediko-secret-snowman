require 'spec_helper'

RSpec.describe Event, type: :model do
  before(:each) do
    @therapist = FactoryGirl.create(:therapist_user)
    @event = FactoryGirl.create(:event)
    @list = FactoryGirl.create(:list, therapist: @therapist.role, event: @event)
  end

  it 'has a valid factory' do
    expect(@event).to be_valid
  end

  it 'properly associates with a list' do
    expect(@event.lists.first.class).to eq List
  end


end
