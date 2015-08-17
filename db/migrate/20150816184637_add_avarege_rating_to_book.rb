class AddAvaregeRatingToBook < ActiveRecord::Migration
  def change
    add_column :books, :average_rating, :integer, default: 0
  end
end
