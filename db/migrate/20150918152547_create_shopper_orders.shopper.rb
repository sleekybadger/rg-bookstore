# This migration comes from shopper (originally 20150913110023)
class CreateShopperOrders < ActiveRecord::Migration
  def change
    create_table :shopper_orders do |t|
      t.integer :state, null: false

      t.integer :customer_id
      t.string :customer_type

      t.integer :delivery_id, index: true

      t.timestamps null: false
    end

    add_index :shopper_orders, :state
    add_index :shopper_orders, [:customer_id, :customer_type]
  end
end
