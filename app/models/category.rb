class Category < ActiveRecord::Base
  has_many :books, dependent: :nullify

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  before_save do
    self.title.capitalize!
  end

  def to_s
    self.title
  end
end
