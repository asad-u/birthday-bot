module Slack
  class CallbacksController < ApplicationController
    include SlackInteraction
    SUBSCRIBED_HOOKS = ['app_uninstalled']

    def event_hook
      if params[:type] == 'url_verification'
        render json: params[:challenge]
      elsif params[:event].present? && SUBSCRIBED_HOOKS.include?(params[:event][:type])
        organization = Organization.find_by_slack_id params[:team_id]
        organization.send params[:event][:type]
      end
    end

  end
end
