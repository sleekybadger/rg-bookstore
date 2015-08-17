class AddTypeToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :type, :string
    add_index  :addresses, :type
  end
end
