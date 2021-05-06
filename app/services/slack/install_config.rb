# frozen_string_literal: true

module Slack
  class InstallConfig
    def initialize(response)
      @response = response
    end

    def update_database
      @organization = Organization.includes(:primary_contact).find_by_slack_id @response['team']['id']
      @user = User.find_by_slack_id @response['authed_user']['id']
      @organization.update(primary_contact: @user)
      reinstalling = @organization.bots.slack.present?
      bot = @organization.bots.create_bot(@response)
      [bot, reinstalling, @organization.primary_contact_name]
    end

    def send_opening_message(bot, contact_name)
      HTTParty.post(bot.webhook_url, body: opening_message(contact_name).to_json)
    end

    private

    def opening_message(name)
      {
        "blocks": [
          {
            "type": 'section',
            "text": {
              "type": 'mrkdwn',
              "text": "Hey team! :wave:\nMy name is BirthdayBot and I’ve been given the best position in the company: CEO of birthday wishes :smiling_face_with_3_hearts:! Thank you #{name} for the position.\nI keep the team informed about upcoming birthdays and when the special day arrives :wink:, I share a fun birthday wish right here in this channel.\nI look forward to celebrating many birthdays to come. :100:"
            }
          },
          {
            "type": 'actions',
            "block_id": 'add-birthday',
            "elements": [
              {
                "type": 'button',
                "text": {
                  "type": 'plain_text',
                  "text": 'Add your birthday :birthday:',
                  "emoji": true
                }
              }
            ]
          }
        ]
      }
    end
  end
end
