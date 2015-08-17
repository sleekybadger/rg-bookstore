class RemoveInStockFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :in_stock
  end
end
