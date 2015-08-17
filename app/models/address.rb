class Address < ActiveRecord::Base

  belongs_to :country, required: true
  belongs_to :addressable, polymorphic: true

  validates :first_name, :last_name, :street, :city, :zip, :phone, presence: true
  validates :zip, numericality: true
  validates :phone, format: { with: /\A\+[\d]+\z/, message: :bad_phone }

end
