class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :note, null: false
      t.integer :rating, null: false
      t.integer :status, null: false

      t.timestamps null: false
    end

    add_reference :reviews, :user, index: true, foreign_key: true
    add_reference :reviews, :book, index: true, foreign_key: true
    add_index :reviews, :status
  end
end
