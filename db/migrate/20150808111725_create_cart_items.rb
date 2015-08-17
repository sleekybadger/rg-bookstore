class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :quantity, null: false

      t.timestamps null: false
    end

    add_reference :cart_items, :cart, index: true, foreign_key: true
    add_reference :cart_items, :book, index: true, foreign_key: true
  end
end
