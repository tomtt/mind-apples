@committed
@pivotal_1381085

Feature: Footer menu
  In order to link together all the pages making up minapples
  As the evil overlord
  I want users to have a menu with links to all the pages

  Scenario: clicking through the site using the footer menu
    When I go to the homepage
    And I follow "Take the test"
    And I follow "Read the fives"
    And I follow "Take the test"
    And I follow "Help us grow"
    And I follow "Take the test"
    And I follow "About us"
    And I follow "Take the test"
    And I follow "Social media"
    And I follow "Read the fives"
    And I follow "Help us grow"
    And I follow "Read the fives"
    And I follow "About us"
    And I follow "Read the fives"
    And I follow "Links"
    And I follow "Help us grow"
    And I follow "About us"
    And I follow "Help us grow"
    And I follow "Links"
    And I follow "About us"
    And I follow "Links"
    And I follow "Take the test"
    Then I should see a link to "blog.mindapples.org"
