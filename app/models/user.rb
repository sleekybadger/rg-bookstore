class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i(facebook)

  has_one :billing_address, as: :addressable, dependent: :destroy
  has_one :shipping_address, as: :addressable, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :orders, dependent: :nullify

  has_and_belongs_to_many :wishes, class_name: 'Book', join_table: 'users_wishes'

  validates :email, :first_name, :last_name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.password = Devise.friendly_token[0,20]
    end
  end

  def to_s
    "#{self.first_name} #{self.last_name}"
  end

  def is_left_review? (book)
    if book.reviews.find_by(user: self)
      true
    else
      false
    end
  end

end
