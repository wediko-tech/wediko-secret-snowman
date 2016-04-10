class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(user)
    user.administrator? ? admin_dashboard_path :
    case user.role_type
    when "Administrator"
      admin_dashboard_path
    when "Therapist"
      wishlists_path
    when "Donor"
      not_implemented_path(target: "the gift request catalog")
    else
      root_path
    end
  end

  def admin_access_denied(user)
    redirect_to root_path, alert: "You are not authorized to access that page."
  end
end
