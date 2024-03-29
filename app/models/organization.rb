class Organization < ApplicationRecord

  has_many :organization_users
  has_many :users, through: :organization_users
  has_many :bots
  has_many :birthdays, -> { order(date: :asc) }

  belongs_to :primary_contact, class_name: 'User', foreign_key: :primary_contact_id

  scope :from_omniauth, lambda { |team_info, user|
    create do |organization|
      organization.name = team_info['name']
      organization.slack_id = team_info['id']
      organization.domain = team_info['domain']
      organization.logo = team_info['image_230']
      organization.primary_contact_id = user.id
    end
  }

  def primary_contact_name
    primary_contact&.full_name
  end

  def installed_in_slack?
    bots.where(source: 'slack', status: 'installed').present?
  end

  def initialize_slack_token
    Slack.configure do |config|
      config.token = (bots.find_by source: 'slack').access_token
    end
    Slack::Web::Client.new
  end

  def app_uninstalled
    bot = bots.find_by_source 'slack'
    bot.update(status: 'uninstalled')
  end

  def next_birthday
    birthdays.where("date < ?", Date.today).order(date: :asc).first
  end
end
