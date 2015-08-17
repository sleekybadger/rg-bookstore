class RemoveCart < ActiveRecord::Migration
  def change
    drop_table :cart_items
    drop_table :carts
  end
end
