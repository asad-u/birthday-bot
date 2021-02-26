# frozen_string_literal: true

module SlackInteraction
  extend ActiveSupport::Concern

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
    end
  end

  private

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

  def parse_payload
    @payload = JSON.parse params[:payload]
  end

  def set_organization
    @organization = Organization.find_by_slack_id @payload['user']['team_id']
  end

  def find_or_create_user
    @user = User.includes(:birthday).first_or_create(slack_id: @payload['user']['id'])
  end

  def update_birthday_modal
    {
      "title": {
        "type": 'plain_text',
        "text": 'Birthday Bot'
      },
      "submit": {
        "type": 'plain_text',
        "text": 'Submit'
      },
      "blocks": [
        {
          "type": 'input',
          "element": {
            "type": 'datepicker',
            "initial_date": @user.birthday&.date.present? ? @user.birthday&.date : '1990-04-28',
            "placeholder": {
              "type": 'plain_text',
              "text": 'Select a date',
              "emoji": true
            },
            "action_id": 'datepicker-action'
          },
          "label": {
            "type": 'plain_text',
            "text": 'Nice! Choose your birthday',
            "emoji": true
          }
        }
      ],
      "type": 'modal'
    }
  end

  def add_birthday
    date = @payload['view']['state']['values'].values.last['datepicker-action']['selected_date']
    Birthday.update_or_create({ user_id: @user.id, organization_id: @organization.id }, { date: date })
  end
end
