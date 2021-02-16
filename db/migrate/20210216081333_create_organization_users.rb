class CreateOrganizationUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :organization_users do |t|
      t.belongs_to :user
      t.belongs_to :organization

      t.timestamps
    end
  end
end
