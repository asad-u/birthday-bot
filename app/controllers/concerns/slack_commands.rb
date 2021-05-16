module SlackCommands
  extend ActiveSupport::Concern
  include ApplicationHelper

  private

  def update_modal
    client = @organization.initialize_slack_token
    client.views_open(trigger_id: params[:trigger_id], view: update_birthday_modal)
  end

  def birthdays_listing
    birthdays = @organization.birthdays
    params[:response_url] ||= @payload['response_url']
    HTTParty.post(params[:response_url], body: listing_message(birthdays).to_json)
  end

  def help_message
    HTTParty.post(params[:response_url], body: helpers.help_message_blocks.to_json)
  end

  def listing_message(birthdays)
    if birthdays.present?
      text = "Here is the list of added birthdays\n\n"
      birthdays.each do |birthday|
        text << "<@#{birthday.user&.slack_id}>: #{birthday.date&.strftime('%d %b, %Y')}\n"
      end
    else
      text = 'No birthdays added yet. You can use `/birthday` command to add yours now :wink:'
    end
    { text: text }
  end
end
