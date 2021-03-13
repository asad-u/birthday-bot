# frozen_string_literal: true

module SlackInteraction
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    skip_before_action :verify_authenticity_token
    before_action :verify_slack_request, :parse_payload, :set_organization, :find_or_create_user
  end

  def interaction
    client = @organization.initialize_slack_token
    if @payload['type'] == 'block_actions'
      client.views_open(trigger_id: @payload['trigger_id'], view: update_birthday_modal)
    else
      add_birthday
      Thread.new do
        send_personal_message(client)
      end
    end
  end

  private

  def parse_payload
    @payload = JSON.parse params[:payload]
  end

  def set_organization
    @organization = Organization.find_by_slack_id @payload['user']['team_id']
  end

  def find_or_create_user
    @user = User.includes(:birthday).where(slack_id: @payload['user']['id']).first_or_create
    @user.update(full_name: @payload['user']['name']) if @user&.full_name.blank?
  end

  def add_birthday
    date = @payload['view']['state']['values'].values.last['datepicker-action']['selected_date']
    @birthday = Birthday.update_or_create({ user_id: @user.id, organization_id: @organization.id }, { date: date })
  end

  def send_personal_message(client)
    client.chat_postMessage(channel: @user.slack_id, text: personal_message)
  end

  def personal_message
    "Thank you for adding your birthday. I'll make sure to remind everyone before `#{@birthday.date&.strftime("%d %B")}` about the special day."
  end
end
