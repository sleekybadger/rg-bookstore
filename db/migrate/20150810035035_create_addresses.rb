class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :street, null: false
      t.string :city, null: false
      t.string :zip, null: false
      t.string :phone, null: false
      t.integer :addressable_id
      t.string  :addressable_type

      t.timestamps null: false
    end

    add_index :addresses, :addressable_id
    add_reference :addresses, :country, index: true, foreign_key: true
  end
end
