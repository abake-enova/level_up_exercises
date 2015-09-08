Feature: Search cards
  In order to efficiently build deadly MTG decks
  As an MTG player
  I will be able to search, filter, and sort cards

  Background: Log in
    Given I'm logged in
    And there are 10 cards in the database

  @javascript
  Scenario: Show tooltips
    Given I visit the card search page
    When I hover over a card's tooltip icon
    Then I will see the tooltip for that card

  @javascript
  Scenario: Search for cards by name
    Given there is a card named "OMG SO OP!" in the database
    And I visit the card search page
    When I search for the card named "OMG SO OP!"
    Then I will see the card named "OMG SO OP!"

  @javascript
  Scenario: Search for cards by type
    Given there is a card with type "creature" in the database
    And I visit the card search page
    When I search for cards with types "creature"
    Then I will see cards with the types "creature"

  @javascript
  Scenario: Search for cards that have two types
    Given there is a card with types "creature,artifact" in the database
    And I visit the card search page
    When I search for cards with types "creature,artifact"
    Then I will see cards with the types "creature,artifact"

  @javascript
  Scenario: Search for cards by text
    Given there is a card with "flying"
    And I visit the card search page
    When I search for cards with keywords "flying"
    Then I will see cards with keywords "flying"

  @javascript
  Scenario: Search for cards by multiple text keywords
    Given there is a card with "flying, deathtouch"
    And I visit the card search page
    When I search for cards with keywords "flying,deathtouch"
    Then I will see cards with keywords "flying, deathtouch"

  @javascript
  Scenario: Search by card color
    Given there is a card with colors "blue"
    And I visit the card search page
    When I search for cards with colors "blue"
    Then I will see cards with colors "blue"

  @javascript
  Scenario: Search by multiple card colors
    Given there is a card with colors "blue,red"
    And I visit the card search page
    When I search for cards with colors "blue,red"
    Then I will see cards with colors "blue,red"

  @javascript
  Scenario: Search by card color, excluding other colors
    Given there is a card with colors "blue"
    And I visit the card search page
    When I search for cards with only colors "blue"
    Then I will see cards with colors "blue"
      And I will not see cards with colors "black,green,red,white"

  @javascript
  Scenario: Search by multicolor
    Given there is a card with colors "blue,red"
    And I visit the card search page
    When I search for multicolor cards
    Then I will only see cards with more than one color

  @javascript
  Scenario: Search by hybrid mana
    Given there is a card with hybrid mana
    And I visit the card search page
    When I search for hybrid mana cards
    Then I will only see cards with hybrid mana

  @javascript
  Scenario: Search by pherexian mana
    Given there is a card with pherexian mana
    And I visit the card search page
    When I search for pherexian mana cards
    Then I will only see cards with pherexian mana

  @javascript
  Scenario: Search by minimum converted mana cost
    Given I visit the card search page
    When I search for cards with converted mana cost greater than or equal to 5
    Then I will only see cards with converted mana cost greater than or equal to 5

  @javascript
  Scenario: Search by maximum converted mana cost
    Given I visit the card search page
    When I search for cards with converted mana cost less than or equal to 5
    Then I will only see cards with converted mana cost less than or equal to 5

  @javascript
  Scenario: Search by exact converted mana cost
    Given I visit the card search page
    When I search for cards with converted mana cost equal to 5
    Then I will only see cards with converted mana cost equal to 5
