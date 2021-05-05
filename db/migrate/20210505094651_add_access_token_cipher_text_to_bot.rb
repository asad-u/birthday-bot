class AddAccessTokenCipherTextToBot < ActiveRecord::Migration[6.1]
  def change
    rename_column :bots, :bot_access_token, :access_token
    add_column :bots, :access_token_ciphertext, :text
    Lockbox.migrate(Bot)
  end
end
