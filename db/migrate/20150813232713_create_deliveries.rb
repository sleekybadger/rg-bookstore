class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :name, null: false
      t.float :price, null: false

      t.timestamps null: false
    end
  end
end
