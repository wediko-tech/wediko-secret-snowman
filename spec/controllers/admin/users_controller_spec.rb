require 'spec_helper'

RSpec.describe Admin::UsersController, type: :controller do
  include AdminSpecHelper

  before :each do
    login_as_admin
  end

  let :user_data do
    {
      user: {
        name: "Jim",
        email: "some@email.com",
        password: "wordpass",
        password_confirmation: "wordpass",
        role_type: "Therapist"
      }
    }
  end

  describe "POST create" do
    it "creates a user's role along with the user" do
      post :create, user_data
      created_user = User.find_by(email: user_data[:user][:email])
      expect(created_user.role).not_to be_nil
      expect(created_user).to be_therapist
    end
  end
end
