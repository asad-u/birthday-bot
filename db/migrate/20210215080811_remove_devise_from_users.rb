class RemoveDeviseFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_sent_at
    remove_column :users, :reset_password_token
    remove_column :users, :remember_created_at

    add_column :users, :full_name, :string
    add_column :users, :slack_id, :string
    add_column :users, :image_url, :string
  end
end
