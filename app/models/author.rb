class Author < ActiveRecord::Base
  has_many :books, dependent: :nullify

  mount_uploader :portrait, PortraitUploader

  paginates_per 10

  validates :first_name, :last_name, presence: true

  before_save do
    self.first_name.capitalize!
    self.last_name.capitalize!
  end

  def to_s
    "#{self.first_name} #{self.last_name}"
  end

  scope :search, -> (query) do
    Author.where('concat_ws(\' \', lower(first_name), lower(last_name)) LIKE ?', "%#{query.to_s.downcase}%")
  end
end
