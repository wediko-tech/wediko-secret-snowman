module AdminSpecHelper
  include Warden::Test::Helpers

  def login_as_admin
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:admin_user)
    sign_in @user
  end

  def login_as_admin_feature
    @user = FactoryGirl.create(:admin_user)
    login_as @user, scope: :user
  end

  def login_as_therapist
    @user = FactoryGirl.create(:therapist_user)
    sign_in @user
  end
end
