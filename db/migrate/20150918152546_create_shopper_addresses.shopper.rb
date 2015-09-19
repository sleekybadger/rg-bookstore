# This migration comes from shopper (originally 20150913110012)
class CreateShopperAddresses < ActiveRecord::Migration
  def change
    create_table :shopper_addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :street, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.string :phone, null: false

      t.integer :addressable_id
      t.string  :addressable_type
      t.string :type

      t.integer :country_id, index: true, null: false

      t.timestamps null: false
    end

    add_index :shopper_addresses, [:addressable_id, :addressable_type, :type], name: 'address_addressable_id_addressable_type_type'
  end
end
