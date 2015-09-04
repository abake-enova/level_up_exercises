class Deck < ActiveRecord::Base
  has_many :cards_decks
  has_many :cards, through: :cards_decks
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true

  def number_of_card_in_deck(card)
    cards_deck = CardsDeck.where(deck_id: id, card_id: card.id).first
    cards_deck ? cards_deck.number_in_deck : 0
  end

  def non_zero_cards
    cards.select { |card| number_of_card_in_deck_by_card_id(card) > 0 }
  end

  def count_card_subset(card_subset)
    card_subset.map(&method(:number_of_card_in_deck)).inject(:+)
  end

  def count_cards_in_deck
    count_card_subset(cards)
  end
end
