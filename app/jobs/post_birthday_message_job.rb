class PostBirthdayMessageJob < ApplicationJob
  queue_as :default

  def perform(bot, message)
    HTTParty.post(bot.webhook_url, body: JSON.generate(message_body(message)))
  end

  private


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
            "text": 'Happy Birthday Powered by GIPHY',
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

end
