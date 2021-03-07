# frozen_string_literal: true

task post_birthdays: :environment do
  Birthday.includes([:user, { organization: :bots }]).each do |birthday|
    next if birthday.date&.strftime('%d %B') != Date.today.strftime('%d %B')

    bot = birthday.organization.bots.find_by source: 'slack'
    next if bot.blank?

    if Date.today.on_weekend?
      time = DateTime.now.next_week.next_day(0).change({ hour: 9 })
      message = "Hey team, <@#{birthday.user&.slack_id}>'s birthday came during weekend, Let's do a party today to celebrate :star-struck:"
    else
      time = DateTime.now.change({ hour: 9 })
      message = "Hey team, please join me in wishing <@#{birthday.user&.slack_id}> a very happy birthday :tada:\nLet's do a party today to celebrate :star-struck:"
    end
    PostBirthdayMessageJob.set(wait_until: time).perform_later(bot, message)
  end
end
