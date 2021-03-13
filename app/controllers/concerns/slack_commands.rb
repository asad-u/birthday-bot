module SlackCommands
  extend ActiveSupport::Concern
  include ApplicationHelper

  def update_modal
    @user = User.find_by_slack_id params[:user_id]
    client = @organization.initialize_slack_token
    client.views_open(trigger_id: params[:trigger_id], view: update_birthday_modal)
  end

  def birthdays_listing
    birthdays = @organization.birthdays
    HTTParty.post(params[:response_url], body: listing_message(birthdays).to_json)
  end

  private

  def listing_message(birthdays)
    if birthdays.present?
      text = "Here is the list of added birthdays\n\n"
      birthdays.each do |birthday|
        text << "<@#{birthday.user&.slack_id}>: #{birthday.date&.strftime('%d %b, %Y')}\n"
      end
    else
      text = 'No birthdays added yet. You can use /birthday command to add yours now :wink:'
    end
    { text: text }
  end
end
