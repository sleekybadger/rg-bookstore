class AddUserToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :user, foreign_key: true, index: true
  end
end
