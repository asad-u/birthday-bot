class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :slack_id
      t.string :domain
      t.string :logo
      t.string :status, default: 'installation_pending'
      t.bigint :primary_contact_id, null: false

      t.timestamps
    end
  end
end
