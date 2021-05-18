module Slack
  class CommandsController < ApplicationController
    include SlackCommands
    skip_before_action :verify_authenticity_token
    before_action :verify_slack_request, :set_user, :set_organization

    def birthday
      which_command
      head :ok
    end

    private

    def set_organization
      @organization = Organization.includes(birthdays: :user).find_by_slack_id params[:team_id]
    end

    def set_user
      @user = User.find_or_create_by slack_id: params[:user_id]
      @user.update(full_name: params[:user_name]) if @user.full_name.blank?
    end

    def which_command
      case params[:text]
      when '', nil
        'update_modal'
      when 'help'
        'help_message'
      when 'list'
        'birthdays_listing'
      else
        'unknown_command'
      end
    end
  end
end
