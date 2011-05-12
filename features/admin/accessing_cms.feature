Feature: Only an admin can access the cms
  In order to manage the mindapples website
  Only an admin must be able to access the cms

  Scenario: Accessing as an admin
    Given I am an admin
    And my login is "andy"
    And I am logged in
    When I go to the CMS page
    Then I should be on the CMS page
    And I should see "Logged in as andy"

  Scenario: Accessing as a person
    Given I have a personal page
    And I am logged in
    When I go to the CMS page
    Then I should see "You must be logged in as an admin"
    And I should be on the homepage
    
  Scenario: Accessing when not logged in
    Given I am not logged in
    When I go to the CMS page
    Then I should be on the login page

  Scenario: Seeing how many people an mindapples there are
    Given I am an admin
    And my login is "andy"
    And my mindapples are:
    | suggestion                       |
    | wrestling with bears in the park |
    | eating ice cream                 |
    | running naked in the park        |

    And I am logged in
    When I go to the CMS page
    And I should see "There are 1 people with 3 mindapples between them"    
