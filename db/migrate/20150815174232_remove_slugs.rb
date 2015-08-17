class RemoveSlugs < ActiveRecord::Migration
  def change
    remove_column :books, :slug
    remove_column :categories, :slug
  end
end
