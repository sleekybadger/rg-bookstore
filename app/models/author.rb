class Author < ActiveRecord::Base

  has_many :books

  validates :first_name, :last_name, presence: true

  before_save do
    self.first_name.capitalize!
    self.last_name.capitalize!
  end

  def to_s
    "#{self.first_name} #{self.last_name}"
  end

end
