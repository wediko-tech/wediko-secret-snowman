module LoginHelper
  include Warden::Test::Helpers

  def login_as_therapist
    @user = FactoryGirl.create(:therapist_user)
    sign_in @user
  end

  def login_as_therapist_feature
    @user = FactoryGirl.create(:therapist_user)
    login_as @user, scope: :user
  end

  def login_as_donor
    @user = FactoryGirl.create(:donor_user)
    sign_in @user
  end

  def login_as_donor_feature
    @user = FactoryGirl.create(:donor_user)
    login_as @user, scope: :user
  end
end
