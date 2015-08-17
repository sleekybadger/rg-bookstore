class CreditCard < ActiveRecord::Base

  belongs_to :order

  validates_with CreditCardExpireValidator
  validates :number, :expiration_month, :expiration_year, :cvv, presence: true
  validates :number, format: { with: /\A\d{16}\z/, message: :bad_card_number }
  validates :cvv, numericality: { only_integer: true }
  validates :expiration_month, numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 12
            }
  validates :expiration_year, numericality: {
              only_integer: true,
              greater_than_or_equal_to: Time.now.year
            }

  def expiration_date
    "#{expiration_month} / #{expiration_year}"
  end

  def secure_number
    chunks = self.number.scan(/.{4}/)
    "**** **** **** #{chunks[3]}"
  end

end
