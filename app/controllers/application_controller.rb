class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(slack_id: session[:user_identifier]) if session[:user_identifier]
  end
end
