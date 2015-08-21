module DecksHelper
  def find_number_of_card_in_deck(deck_id, card_id)
    cards_deck = find_cards_deck(deck_id, card_id)
    cards_deck ? cards_deck.number_in_deck : 0
  end

  def find_cards_deck(deck_id, card_id)
    CardsDeck.where(deck_id: deck_id).where(card_id: card_id)[0]
  end

  def non_zero_cards_in_deck(deck)
    deck.cards.select { |card| find_number_of_card_in_deck(deck.id, card.id) > 0 }
  end

  def total_number_of_card_subset_in_deck(deck, card_subset)
    card_subset.map { |card| find_number_of_card_in_deck(deck.id, card.id) }.inject(:+)
  end
end
