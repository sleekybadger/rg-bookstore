class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :quantity, null: false

      t.timestamps null: false
    end

    add_reference :order_items, :order,
                  index: true, foreign_key: true, null: false
    add_reference :order_items, :book,
                  index: true, foreign_key: true, null: false
  end
end
