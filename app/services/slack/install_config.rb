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
      bot = @organization.bots.create_bot(@response)
      [bot, @organization.primary_contact_name]
    end

    def send_opening_message(settings)
      HTTParty.post(settings.first&.webhook_url, body: { text: opening_message(settings&.last) }.to_json)
    end

    private

    def opening_message(name)
      "Hey team!\nMy name is BirthdayBot and I’ve been given the best position in the company: CEO of birthday wishes! Thank you #{name} for the position.\nI keep the team informed about upcoming birthdays and when the special day arrives, I share a fun birthday wish right here in this channel.\nI look forward to celebrating many birthdays to come."
    end
  end
end
