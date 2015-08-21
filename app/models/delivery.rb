class Delivery < ActiveRecord::Base

  has_many :orders, dependent: :nullify

  validates :name, :price, presence: true
  validates :price, numericality: true

  def to_s
    self.name
  end

end
