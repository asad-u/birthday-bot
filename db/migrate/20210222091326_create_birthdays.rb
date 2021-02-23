class CreateBirthdays < ActiveRecord::Migration[6.1]
  def change
    create_table :birthdays do |t|
      t.date :date
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
