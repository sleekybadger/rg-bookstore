class AddIndexToCoutries < ActiveRecord::Migration
  def change
    add_index :countries, :name, unique: true
  end
end
