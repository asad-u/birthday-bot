# frozen_string_literal: true

module Slack
  class Oauth
    def initialize(code, redirect_uri)
      @code = code
      @request_token_params = {
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_APP_SECRET'],
        code: @code,
        redirect_uri: redirect_uri
      }
    end

    def sign_in_user
      request_url = URI::HTTPS.build(host: 'www.slack.com', path: '/api/oauth.v2.access', query: @request_token_params.to_query)
      request_response = HTTParty.get request_url
      return unless request_response['ok']

      @user = User.find_by_slack_id request_response['authed_user']['id']
      @organization = Organization.find_by_slack_id request_response['team']['id']
      organization_and_user(request_response) if @user.blank? || @organization.blank?
      [@user, @organization]
    end

    private

    def organization_and_user(request_response)
      workspace_information = request_user_identity(request_response['authed_user']['access_token'])
      @user = User.from_omniauth(workspace_information['user']) if @user.blank?
      @organization = @user.organizations.from_omniauth(workspace_information['team'], @user) if @organization.blank?
    end

    def request_user_identity(access_token)
      return if access_token.blank?

      headers = {
        Authorization: "Bearer #{access_token}"
      }
      request_response = HTTParty.get('https://slack.com/api/users.identity', headers: headers)
      request_response['ok'] ? request_response : nil
    end
  end
end
