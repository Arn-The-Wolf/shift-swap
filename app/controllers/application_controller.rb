class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "Please sign in to continue."
  end

  def require_manager
    return if current_user&.manager?

    redirect_to dashboard_path, alert: "Managers only."
  end
end
