module Slack
  class CommandsController < ApplicationController
    include SlackCommands
    skip_before_action :verify_authenticity_token
    before_action :verify_slack_request, :set_organization

    def birthday
      method = params[:text].blank? ? 'update_modal' : 'birthdays_listing'
      send method
      head :ok
    end

    private

    def set_organization
      @organization = Organization.includes(:birthdays).find_by_slack_id params[:team_id]
    end
  end
end