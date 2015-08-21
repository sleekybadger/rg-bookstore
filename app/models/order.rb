class Order < ActiveRecord::Base

  include AASM

  has_many :order_items, dependent: :destroy

  has_one :billing_address, as: :addressable, dependent: :destroy
  has_one :shipping_address, as: :addressable, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  belongs_to :delivery
  belongs_to :user

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :credit_card

  paginates_per 2

  enum state: %i(in_progress in_queue in_delivery delivered canceled)

  aasm column: :state, enum: true, whiny_transitions: false  do
    state :in_progress, initial: true
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled

    event :place_order do
      transitions from: :in_progress, to: :in_queue do
        guard do
          self.ready_for_checkout?
        end
      end
    end
  end

  def items_total_price
    order_items.map(&:total_price).inject(&:+)
  end

  def total_price
    total =  items_total_price
    total += delivery ? delivery.price : 0
    total.round(2)
  end

  def ready_for_checkout?
    delivery.present? && billing_address.present? &&
      shipping_address.present? && credit_card.present?
  end

  def to_s
    "Order #{self.id}"
  end

end
