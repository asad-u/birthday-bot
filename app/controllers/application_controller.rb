class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.includes(:organizations).find_by(slack_id: session[:user_identifier]) if session[:user_identifier]
  end

  def authenticate_user!
    redirect_to root_path unless current_user
  end
end
