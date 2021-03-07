# frozen_string_literal: true

task post_birthdays: :environment do
  Birthday.includes([:user, { organization: :bots }]).each do |birthday|
    next if birthday.date&.strftime('%d %B') != Date.today.strftime('%d %B')

    bot = birthday.organization.bots.find_by source: 'slack'
    next if bot.blank?

    if Date.today.on_weekend?
      message = "Hey team, <@#{birthday.user&.slack_id}>'s birthday came during weekend, Let's do a party today to celebrate :star-struck:"
    else
      message = "Hey team, please join me in wishing <@#{birthday.user&.slack_id}> a very happy birthday :tada:\nLet's do a party today to celebrate :star-struck:"
    end
    HTTParty.post(bot.webhook_url, body: JSON.generate(message_body(message)))
  end
end

def message_body(message)
  gif = birthday_gif

  {
    "blocks": [
      {
        "type": 'section',
        "text": {
          "type": 'mrkdwn',
          "text": message
        }
      },
      {
        "type": 'image',
        "title": {
          "type": 'plain_text',
          "text": 'Happy Birthday',
          "emoji": true
        },
        "image_url": gif.present? ? gif : 'https://media.giphy.com/media/lNByEO1uTbVAikv8oT/giphy.gif',
        "alt_text": 'happy birthday'
      }
    ]
  }
end

def birthday_gif
  query = URI::HTTPS.build(host: 'api.giphy.com', path: '/v1/gifs/search', query: api_opts.to_query)
  result = HTTParty.get(query)
  return if result['data'].blank?

  result['data'].sample['images']['downsized']['url']
end

def api_opts
  {
    rating: 'pg-13',
    lang: 'en',
    fmt: 'json',
    offset: 0,
    limit: 25,
    api_key: ENV['GIPHY_KEY'],
    q: 'birthday'
  }
end
