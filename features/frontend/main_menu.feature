@committed

Feature: Main menu
  In order to be able to see where I am on the site
  As a person
  I want the tab that corresponds to the current page to be highlighted

  Scenario: Going to different pages and checking the highlighting in the menu bar
    When I go to the homepage
    Then only "Home" should be highlighted in the main menu

    When I follow "Your 5-a-day"
    Then only "Your 5-a-day" should be highlighted in the main menu

    When I follow "Services"
    Then only "Services" should be highlighted in the main menu

    When I follow "Join us"
    Then only "Join us" should be highlighted in the main menu

    When I follow "About us"
    Then only "About us" should be highlighted in the main menu

  Scenario: A logged in user belonging to a network goes to different pages and checks the highlighting in the menu bar
    Given a network exists with name: "4Beauty", description: "The 4Beauty form", url: "4beauty"
    And a network exists with name: "Lambeth"
    And I have a personal page
    And my password is "eagleeyed"
    And I belong to the "4Beauty" network
    When I log in

    When I go to the homepage
    Then only "Home" should be highlighted in the main menu

    When I follow "Your 5-a-day"
    Then only "Your 5-a-day" should be highlighted in the main menu

    When I follow "Services"
    Then only "Services" should be highlighted in the main menu

    When I follow "Join us"
    Then only "Join us" should be highlighted in the main menu

    When I follow "About us"
    Then only "About us" should be highlighted in the main menu

    When I follow "My community"
    Then only "My community" should be highlighted in the main menu

