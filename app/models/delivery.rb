class Delivery < ActiveRecord::Base

  has_many :orders

  validates :name, :price, presence: true
  validates :price, numericality: true

  def to_s
    self.name
  end

  def beauty_price
    '%.2f' % self.price
  end

end
