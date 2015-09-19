class RemoveTableForCartEngine < ActiveRecord::Migration
  def up
    drop_table :addresses
    drop_table :countries
    drop_table :credit_cards
    drop_table :order_items
    drop_table :orders
    drop_table :deliveries
  end

  def down
  end
end
