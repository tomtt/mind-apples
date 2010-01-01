@pivotal_1292369

Feature: Anonymous personal page

  Scenario: Person sees his page
    When I go to the "take the test" page
    And I press "Submit"
    Then I should see "Your page on Mindapples"

  Scenario: Sombody else sees his page
    Given I have a personal page
    When I go to my mindapples page
    Then I should see "Somebody's page on Mindapples"
