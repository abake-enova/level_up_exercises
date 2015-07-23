Feature: Destroying the world
  In order to verify that the bomb can properly be detonated
  As a supervillian
  I should be able to detonate the bomb and destroy the world

  Scenario: Destroying the world
    Given I visit the home page
    When I boot up the bomb
    And I activate the bomb with code 1234
    And I fail at deactivating the bomb
    Then the world should be destroyed