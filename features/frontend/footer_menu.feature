@committed
@pivotal_1381085

Feature: Footer menu
  In order to link together all the pages making up mindapples
  As the evil overlord
  I want users to have a menu with links to all the pages

  Scenario Outline: clicking all the links in the footer menu of a page
    When I go to the <page>
    And I follow "Your 5-a-day"
    And I go to the <page>
    And I follow "Services"
    And I go to the <page>
    And I follow "Join us"
    And I go to the <page>
    And I follow "About us"
    And I go to the <page>
    And I follow "Contact"
    And I go to the <page>
    Then I should see a link to "blog.mindapples.org"

    Examples:
    | page                 |
    | homepage             |
    | "about" page         |
    | "services" page      |
    | "Your 5-a-day" page  |
    | "contact" page       |
    | "grow" page          |
