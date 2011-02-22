@committed
@pivotal_1381085

Feature: Footer menu
  In order to link together all the pages making up mindapples
  As the evil overlord
  I want users to have a menu with links to all the pages

  Scenario Outline: clicking al the links in the footer menu of a page
    When I go to the <page>
    And I follow "Take the test"
    And I go to the <page>
    And I follow "Explore"
    And I go to the <page>
    And I follow "Help us grow"
    And I go to the <page>
    And I follow "About us"
    And I go to the <page>
    Then I should see a link to "blog.mindapples.org"

    Examples:
    | page                 |
    | homepage             |
    | "about" page         |
    | "take the test" page |
    | "fives" page         |
    | "help us grow" page  |
