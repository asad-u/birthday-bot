class RemoveAccessTokenFromBots < ActiveRecord::Migration[6.1]
  def change
    remove_column :bots, :access_token
  end
end
