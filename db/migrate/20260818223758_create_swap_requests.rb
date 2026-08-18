class CreateSwapRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :swap_requests do |t|
      t.string :status, null: false, default: "pending"
      t.references :requesting_user, null: false, foreign_key: { to_table: :users }
      t.references :target_user, null: false, foreign_key: { to_table: :users }
      t.references :shift, null: false, foreign_key: true

      t.timestamps
    end

    add_index :swap_requests, :status
  end
end
