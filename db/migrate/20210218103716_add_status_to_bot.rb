class AddStatusToBot < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :status, :string, default: 'installed'
    # remove status from organizations
    remove_column :organizations, :status
  end
end
