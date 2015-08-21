class Book < ActiveRecord::Base

  belongs_to :author
  belongs_to :category

  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy

  mount_uploader :cover, CoverUploader

  paginates_per 10

  validates :title, :price, presence: true
  validates :price, numericality: true
  validates :short_description, length: { maximum: 500 }
  validates :full_description, length: { maximum: 2000 }

  scope :best_sellers, -> (num = 3) do
    ids = OrderItem
            .select('book_id, sum(quantity) as quantity')
            .joins(:order)
            .where(orders: {state: Order.states[:delivered]})
            .group(:book_id)
            .order('quantity')
            .offset(0)
            .limit(num)
            .map(&:book_id)

    where(id: ids)
  end

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
    if reviews.approved.empty?
      0
    else
      rating = reviews.approved.map(&:rating).inject(&:+)
      rating = rating / reviews.approved.size
      rating.floor
    end
  end

  def calculate_average_rating!
    self.average_rating = calculate_average_rating
    self.save
  end

end
