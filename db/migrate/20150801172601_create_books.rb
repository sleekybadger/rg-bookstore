class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :cover

      t.text :short_description
      t.text :full_description

      t.float :price

      t.integer :in_stock

      t.timestamps null: false
    end

    add_reference :books, :category, index: true, foreign_key: true
    add_reference :books, :author, index: true, foreign_key: true
    add_index :books, :slug, unique: true
  end
end
