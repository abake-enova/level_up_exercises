def edit_deck(deck)
  visit(edit_deck_path(deck))
end

def add_card(card_id)
  selector = "tr[data-card-id=\"#{card_id}\"] a.add"
  find(selector, match: :first).click
end

def add_random_card_to_deck
  card_id = Card.offset(rand(Card.count)).first.id
  add_card(card_id)
  @added_cards << card_id
  @added_card = card_id
end

def remove_card(card_id)
  selector = "tr[data-card-id=\"#{card_id}\"] a.remove"
  find(selector, match: :first).click
end

def create_deck
  @deck = create(:deck, user: @user)
end

Given(/^I am editing my deck$/) do
  create_deck
  edit_deck(@deck)
  @added_cards = []
  @removed_cards = []
end

When(/^I create a deck named (.*)$/) do |deck_name|
  fill_in 'deck[name]', with: deck_name
  click_button 'Create New Deck'
end

When(/^I destroy the deck named (.*)$/) do |deck_name|
  deck_id = Deck.where(name: deck_name).first.id
  visit(user_path(@user))
  selector = "li[data-deck-id=\"#{deck_id}\"] a.destroy"
  find(selector, match: :first).click
end

When(/^I visit the create deck page$/) do
  visit("/decks/new")
end

When(/^I create a deck$/) do
  create_deck
end

When(/^I visit the edit deck page$/) do
  edit_deck(@deck)
end

When(/^I add a card to my deck$/) do
  add_random_card_to_deck
end

When(/^I add (\d+) cards to my deck$/) do |n|
  n.to_i.times { |_| add_random_card_to_deck }
end

When(/^I remove that card$/) do
  remove_card(@added_card)
  @removed_cards << @added_card
  @removed_card = @added_card
end

When(/^I remove a card$/) do
  card_id = @added_cards.sample
  remove_card(card_id)
  @removed_cards << card_id
  @removed_card = card_id
end

Then(/^I expect to not have a deck named (.*)$/) do |deck_name|
  visit(user_path(@user))
  expect(find(".user-decks", match: :first)).to_not have_content(deck_name)
end

Then(/^I expect to have (.*) deck named (.*)$/) do |n, deck_name|
  expect(@user.decks.count).to eq(1)
  expect(@user.decks.first.name).to eq(deck_name)
end

Then(/^I expect to have (.*) cards in my deck$/) do |n|
  expect(page).to have_selector(".card-in-deck", count: n)
end

Then(/^I expect to have the cards I added in my deck$/) do
  @added_cards.each do |card_id|
    expect(page).to have_selector(".card-in-deck[data-card-id=\"#{card_id}\"]")
  end
end

Then(/^I expect the removed cards to not be in my deck$/) do
  @removed_cards.each do |card_id|
    expect(page).to_not have_selector(".card-in-deck[data-card-id=\"#{card_id}\"]")
  end
end
