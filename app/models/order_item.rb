class OrderItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :book

  validates :order, :book, :quantity, presence: true
  validates :quantity, numericality: {
                        only_integer: true,
                        greater_than_or_equal_to: 1
                      }

  def total_price
    self.quantity * self.book.price
  end

  def reduce_quantity(quantity = 1)
    self.quantity -= quantity.to_i

    if self.quantity > 0
      self.save
    else
      self.destroy
    end
  end

end
