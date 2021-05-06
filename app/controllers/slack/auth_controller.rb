class Slack::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:sign_in, :install]
  before_action :authenticate_user!, only: [:sign_out, :install]

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

  def install
    request_response = Slack::Oauth.new(params[:code], slack_install_url).request_access_token
    if request_response['ok']
      install_service = Slack::InstallConfig.new(request_response)
      bot, reinstalling, contact_name = install_service.update_database
      install_service.send_opening_message(bot, contact_name) unless reinstalling
      redirect_to root_path, notice: 'Successfully installed.'
    else
      redirect_to root_path, alert: 'There was a problem installing the app.'
    end
  end
end
