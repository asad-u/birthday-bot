class Organization < ApplicationRecord
  self.strict_loading_by_default = true

  has_many :organization_users
  has_many :users, through: :organization_users

  belongs_to :primary_contact, class_name: 'User', foreign_key: :primary_contact_id
  enum status: { installed: 'installed', uninstalled: 'uninstalled', installation_pending: 'installation_pending' }

  scope :from_omniauth, lambda { |team_info, user|
    create do |organization|
      organization.name = team_info['name']
      organization.slack_id = team_info['id']
      organization.domain = team_info['domain']
      organization.logo = team_info['image_230']
      organization.primary_contact_id = user.id
    end
  }
end
