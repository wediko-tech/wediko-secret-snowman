module LoginHelper
  include Warden::Test::Helpers

  def login_as_therapist(user = nil)
    @user = user || FactoryGirl.create(:therapist_user)
    sign_in @user
  end

  def login_as_therapist_feature(user = nil)
    @user = user || FactoryGirl.create(:therapist_user)
    login_as @user, scope: :user
  end

  def login_as_donor(user = nil)
    @user = user || FactoryGirl.create(:donor_user)
    sign_in @user
  end

  def login_as_donor_feature(user = nil)
    @user = user || FactoryGirl.create(:donor_user)
    login_as @user, scope: :user
  end
end
