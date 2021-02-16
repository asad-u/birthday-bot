class Slack::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :sign_in
  before_action :authenticate_user!, only: :sign_out

  def sign_in
    oauth_service = Slack::Oauth.new(params[:code], slack_auth_redirect_url)
    user_and_organization = oauth_service.sign_in_user
    if user_and_organization.present?
      session[:user_identifier] = user_and_organization.first&.slack_id
      redirect_to root_path, notice: 'Login Successful.'
    else
      redirect_to root_path, alert: 'Login Failed.'
    end
  end

  def sign_out
    session[:user_identifier] = nil
    redirect_to root_path
  end
end
