class Type < ActiveRecord::Base
  has_many :cards_types
  has_many :cards, through: :cards_types
  validates :name, presence: true,
                   uniqueness: true
end
