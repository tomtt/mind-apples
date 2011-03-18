@committed

Feature: Main menu
  In order to be able to see where I am on the site
  As a person
  I want the tab that corresponds to the current page to be highlighted

  Scenario: Going to different pages and checking the highlighting in the menu bar
    When I go to the "about" page
    Then I should see "About Mindapples"
