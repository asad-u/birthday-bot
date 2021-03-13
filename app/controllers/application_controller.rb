class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.includes(:organizations).find_by(slack_id: session[:user_identifier]) if session[:user_identifier]
  end

  def authenticate_user!
    redirect_to root_path unless current_user
  end

  def verify_slack_request
    timestamp = request.headers['X-Slack-Request-Timestamp']
    if (Time.now.to_i - timestamp.to_i).abs > 60 * 5
      head :unauthorized
      return
    end
    sig_base_string = "v0:#{timestamp}:#{request.raw_post}"
    signature = "v0=#{OpenSSL::HMAC.hexdigest('SHA256', ENV['SLACK_SIGNING_SECRET'], sig_base_string)}"
    slack_signature = request.headers['X-Slack-Signature']
    head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(signature, slack_signature)
  end
end
