class AddDiliveryToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :delivery, index: true, foreign_key: true
  end
end
