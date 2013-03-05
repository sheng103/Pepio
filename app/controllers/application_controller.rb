class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :admin_user
  
  def login_required
    if current_user || admin_user
      return true
    else
      redirect_to admin_login_url
    end
  end
  
  def admin_required
    #if current_user && current_user.is_admin?
    if admin_user && current_user.is_admin?
      return true
    else
      redirect_to logout_url
    end
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def admin_user
    @admin_user ||= User.find(session[:admin_id]) if session[:admin_id]
  end
end
