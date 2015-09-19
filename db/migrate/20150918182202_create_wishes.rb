class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
