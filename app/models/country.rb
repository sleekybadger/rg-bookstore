class Country < ActiveRecord::Base

  has_many :addresses, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save do
    self.name = self.name.split(' ').map(&:capitalize).join(' ')
  end

  def to_s
    self.name
  end

end
