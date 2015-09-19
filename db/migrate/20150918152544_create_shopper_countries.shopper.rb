# This migration comes from shopper (originally 20150913105916)
class CreateShopperCountries < ActiveRecord::Migration
  def change
    create_table :shopper_countries do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    add_index :shopper_countries, :name, unique: true
  end
end
