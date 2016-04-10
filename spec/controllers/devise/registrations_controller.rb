require 'spec_helper'

describe Devise::RegistrationsController do
  let(:user_info) { {email: "email@email.com", password: "wordpass",
        password_confirmation: "wordpass", name: "Some Name"} }
  let(:donor_user_info) { user_info.merge(role_type: "Donor") }
  let(:admin_user_info) { user_info.merge(role_type: "Administrator") }

  describe "POST #create" do
    it "adds a role after user creation" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: donor_user_info

      user = User.find_by(email: user_info[:email])
      expect(user).to be_donor
    end

    it "does not let a user become an admin" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      post :create, user: admin_user_info

      user = User.find_by(email: user_info[:email])
      expect(user).not_to be_administrator
    end
  end
end
