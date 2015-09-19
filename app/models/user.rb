class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: %i(facebook)

  register_as_customer

  has_many :reviews, dependent: :destroy
  has_many :wishes, dependent: :destroy

  has_one :billing_address, class_name: 'Shopper::BillingAddress',
                            as: :addressable, dependent: :destroy
  has_one :shipping_address, class_name: 'Shopper::ShippingAddress',
                              as: :addressable, dependent: :destroy

  validates :first_name, :last_name, presence: true

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first
    return user if user

    user = find_by_email(auth.info.email)
    if user
      update(user.id, provider: auth.provider, uid: auth.uid)
    else
      create do |u|
        u.email = auth.info.email
        u.first_name = auth.info.first_name
        u.last_name = auth.info.last_name
        u.password = Devise.friendly_token[0,20]
      end
    end
  end

  def to_s
    "#{self.first_name} #{self.last_name}"
  end

  def is_left_review?(book)
    !!(book.reviews.approved.find_by(user: self) ||
      book.reviews.unmoderated.find_by(user: self))
  end
end
