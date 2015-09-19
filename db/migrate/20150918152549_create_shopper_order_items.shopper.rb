# This migration comes from shopper (originally 20150913110730)
class CreateShopperOrderItems < ActiveRecord::Migration
  def change
    create_table :shopper_order_items do |t|
      t.integer :quantity, null: false

      t.string :product_type, null: false
      t.integer :product_id, null: false

      t.integer :order_id, index: true, null: false

      t.timestamps null: false
    end

    add_index :shopper_order_items, [:product_type, :product_id]
  end
end
