@committed

Feature: Main menu
  In order to be able to see where I am on the site
  As a person
  I want the tab that corresponds to the current page to be highlighted

  Scenario: Going to different pages and checking the highlighting in the menu bar
    When I go to the homepage
    Then "Home" should be highlighted in the main menu

    When I follow "About us"
    Then "About us" should be highlighted in the main menu

    When I follow "Explore"
    Then "Explore" should be highlighted in the main menu

    When I follow "Hire us"
    Then "Hire us" should be highlighted in the main menu

    When I follow "Join us"
    Then "Join us" should be highlighted in the main menu

    When I follow "About us"
    Then "About us" should be highlighted in the main menu

    When I follow "Explore"
    Then "Explore" should be highlighted in the main menu
    When I fill in "mindapple" with "garble"
    And I press "Find"
    Then "Explore" should be highlighted in the main menu

