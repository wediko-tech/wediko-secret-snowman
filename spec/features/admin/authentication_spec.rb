require 'spec_helper'

describe 'admin authentication' do
  include AdminSpecHelper
  include LoginHelper

  it "should allow admins to access the admin panel" do
    login_as_admin_feature

    visit admin_dashboard_path
    expect(current_path).to eq admin_dashboard_path
  end

  it "should forbid non-admins from accessing the admin panel" do
    login_as_therapist_feature

    visit admin_dashboard_path
    expect(current_path).to eq root_path
  end
end
