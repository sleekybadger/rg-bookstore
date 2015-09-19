class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category

  has_many :reviews, dependent: :destroy
  has_many :wishes, dependent: :destroy

  mount_uploader :cover, CoverUploader

  register_as_product

  paginates_per 10

  validates :title, :price, presence: true
  validates :price, numericality: true
  validates :short_description, length: { maximum: 500 }
  validates :full_description, length: { maximum: 2000 }

  scope :search, -> (query) do
    Book.where('lower(title) LIKE ?', "%#{query.to_s.downcase}%")
  end

  before_save do
    self.title = self.title.split(' ').map(&:capitalize).join(' ')
  end

  def to_s
    self.title
  end

  def calculate_average_rating
    begin
      rating = reviews.approved.map(&:rating).inject(&:+)
      rating = rating / reviews.approved.size
      rating.floor
    rescue
      0
    end
  end

  def calculate_average_rating!
    update(average_rating: calculate_average_rating)
  end
end
