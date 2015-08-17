class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :rememberable, :omniauthable, :validatable

  has_one :billing_address, as: :addressable, dependent: :destroy
  has_one :shipping_address, as: :addressable, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :orders

  validates :email, :first_name, :last_name, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A.+@.+\z/, message: :bad_email }

  def to_s
    "#{self.first_name} #{self.last_name}"
  end

  def is_left_review? (book)
    if book.reviews.where(user: self).empty?
      false
    else
      true
    end
  end

end
