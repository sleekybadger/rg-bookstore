class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :state, null: false

      t.timestamps null: false
    end

    add_index :orders, :state
  end
end
