class MtgSet < ActiveRecord::Base
  has_many :cards_types
  has_many :cards, through: :cards_mtg_sets
  validates :set_id, presence: true,
                     uniqueness: true
  validates :name, presence: true,
                   uniqueness: true
  validates :set_type, presence: true
end
