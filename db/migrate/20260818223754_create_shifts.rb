class CreateShifts < ActiveRecord::Migration[8.1]
  def change
    create_table :shifts do |t|
      t.string :title, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end

    add_index :shifts, :starts_at
  end
end
