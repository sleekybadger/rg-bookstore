class Wish < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :user, :book, presence: true
  validates_uniqueness_of :user_id, scope: :book_id
end
