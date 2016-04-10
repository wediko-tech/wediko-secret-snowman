class AdminAuthorization < ActiveAdmin::AuthorizationAdapter
  # only administrators can do anything on the admin panel
  def authorized?(action, subject = nil)
    user.administrator?
  end
end
