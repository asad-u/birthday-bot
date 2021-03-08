class User < ApplicationRecord

  has_many :organization_users
  has_many :organizations, through: :organization_users
  has_one :birthday

  def self.from_omniauth(user_info)
    create do |user|
      user.slack_id = user_info['id']
      user.email = user_info['email']
      user.full_name = user_info['name']
      user.image_url = user_info['image_512']
    end
  end
end
