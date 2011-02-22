@wip

Feature: Only an admin can access the cms
  In order to manage the mindapples website
  Only an admin must be able to access the cms

  Scenario: Accessing as an admin
    Given I am an admin
    And I am logged in
    When I go to the CMS page
    Then I should be on the CMS page

  Scenario: Accessing as a person
    Given I have a personal page
    And I am logged in
    When I go to the CMS page
    Then I should see "Access denied"
    And I should be on the homepage
    
  Scenario: Accessing when not logged in
    Given I am not logged in
    When I go to the CMS page
    Then I should be on the login page
