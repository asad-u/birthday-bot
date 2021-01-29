class Organization < ApplicationRecord
  has_many :users
  belongs_to :primary_contact, class_name: 'User', foreign_key: :primary_contact_id
end
