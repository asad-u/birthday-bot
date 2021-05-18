# frozen_string_literal: true

module SlackInteraction
  extend ActiveSupport::Concern
  include ApplicationHelper

  included do
    skip_before_action :verify_authenticity_token
    before_action :verify_slack_request
    before_action :parse_payload, :set_organization, :find_or_create_user, only: [:interaction]
  end

  def interaction
    case @payload['type']
    when 'block_actions'
      case @payload['actions'][0]['action_id']
      when 'add-birthday'
        trigger_modal
      when 'next-birthday'
        next_birthday_message
      when 'complete-list'
        birthdays_listing
      end
    when 'view_submission'
      add_birthday
      Thread.new do
        client = @organization.initialize_slack_token
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

  def trigger_modal
    client = @organization.initialize_slack_token
    client.views_open(trigger_id: @payload['trigger_id'], view: update_birthday_modal)
  end

  def next_birthday_message
    next_birthday = @organization.next_birthday
    text = next_birthday.present? ? "<@#{next_birthday.user.slack_id}>: #{next_birthday.date.strftime('%d %b, %Y')}" : 'No birthdays added.'
    HTTParty.post(@payload['response_url'], body: { text: text }.to_json)
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
