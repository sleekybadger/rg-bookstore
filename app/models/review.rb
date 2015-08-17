class Review < ActiveRecord::Base

  include AASM

  RATING = 1..5

  enum status: %i(unmoderated approved rejected)

  belongs_to :book
  belongs_to :user

  validates :note, :rating, :status, :book, :user, presence: true
  validates :note, length: { maximum: 500 }
  validates :rating, inclusion: { in: RATING }

  after_save :recalculate_book_rating

  paginates_per 10

  aasm column: :status, enum: true do
    state :unmoderated, initial: true
    state :approved
    state :rejected

    event :approve do
      transitions from: %i(unmoderated rejected), to: :approved
    end

    event :reject do
      transitions from: %i(unmoderated approved), to: :rejected
    end
  end

  private

    def recalculate_book_rating
      self.book.calculate_average_rating!
    end

end
