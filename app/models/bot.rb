class Bot < ApplicationRecord
  belongs_to :organization

  encrypts :access_token

  enum status: { installed: 'installed', uninstalled: 'uninstalled' }
  enum source: { slack: 'slack' }

  scope :create_bot, lambda { |bot_info|
    update_params = {
      access_token: bot_info['access_token'], bot_id: bot_info['bot_user_id'],
      channel_name: bot_info['incoming_webhook']['channel'], channel_id: bot_info['incoming_webhook']['channel_id'],
      webhook_configuration_url: bot_info['incoming_webhook']['configuration_url'],
      webhook_url: bot_info['incoming_webhook']['url'], status: 'installed'
    }
    update_or_create({ source: 'slack' }, update_params)
  }

end
