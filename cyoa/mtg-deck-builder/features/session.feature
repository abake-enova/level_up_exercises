Feature: Logging in and logging out
  In order to save MTG decks
  As a MTG player
  I should be able to log in and log out

  Background: Create user
    Given I created a user

  Scenario: Log in
    When I log in
    Then I should be logged in

  Scenario: Log Out
    Given I log in
    When I log out
    Then I should be logged out
