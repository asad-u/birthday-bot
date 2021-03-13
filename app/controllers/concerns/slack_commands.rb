module SlackCommands
  extend ActiveSupport::Concern
  include ApplicationHelper

  def update_modal
    @user = User.find_by_slack_id params[:user_id]
    client = @organization.initialize_slack_token
    client.views_open(trigger_id: params[:trigger_id], view: update_birthday_modal)
  end

  def birthdays_listing
    birthdays_hash = @organization.birthdays.group_by_month(series: true, &:date)
    HTTParty.post(params[:response_url], body: listing_message(birthdays_hash).to_json)
  end

  private

  def listing_message(birthdays_hash)
    if birthdays_hash.present?
      text = "Here is the list of upcoming birthdays\n\n"
      Hash[birthdays_hash.sort_by { |k, _v| k.month && k.day }].each do |date, birthdays|
        birthdays.each do |birthday|
          text << "*#{birthday.user&.full_name}*: #{date&.strftime('%d %b, %Y')}"
        end
      end
    else
      text = 'No birthdays added yet. You can use /birthday command to add yours now :wink:'
    end
    { text: text }
  end
end
