# This migration comes from shopper (originally 20150913110427)
class CreateShopperCreditCards < ActiveRecord::Migration
  def change
    create_table :shopper_credit_cards do |t|
      t.string :number, null: false
      t.integer :expiration_month, null: false
      t.integer :expiration_year, null: false
      t.integer :cvv, null: false

      t.integer :order_id, index: true

      t.timestamps null: false
    end
  end
end
