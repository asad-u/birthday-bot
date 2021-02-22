class CreateBots < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|
      t.string :bot_id
      t.string :bot_access_token
      t.string :source
      t.string :channel_name
      t.string :channel_id
      t.string :webhook_configuration_url
      t.string :webhook_url
      t.belongs_to :organization

      t.timestamps
    end
  end
end
