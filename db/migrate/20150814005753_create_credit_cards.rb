class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string :number, null: false
      t.integer :expiration_month, null: false
      t.integer :expiration_year, null: false
      t.integer :cvv, null: false

      t.timestamps null: false
    end

    add_reference :credit_cards, :order, index: true, foreign_key: true
  end
end
