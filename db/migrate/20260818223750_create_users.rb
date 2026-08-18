class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :team, null: false, foreign_key: true
      t.boolean :manager, null: false, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
