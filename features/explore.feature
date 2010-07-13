@pivotal_4192987
@wp
Feature: Explore page
  In order to search for mindapples
  As the curios cat
  I want search box and mindapples cloud

  Scenario: Searching for mindapples
    Given I am on the "Explore" page
    And a mindapple "mindapple1" exists with suggestion: "wrestling with bears in the park"
    And a mindapple "mindapple2" exists with suggestion: "eating ice cream"
    And a mindapple "mindapple3" exists with suggestion: "running naked in the park"

    When I fill in "mindapple" with "park"
    And I press "Find"
    Then I should see "wrestling with bears in the park"
    And I should see "running naked in the park"

  Scenario: Searching for mindapples without any result
    Given I am on the "Explore" page
    And a mindapple "mindapple1" exists with suggestion: "wrestling with bears in the park"
    And a mindapple "mindapple2" exists with suggestion: "eating ice cream"
    And a mindapple "mindapple3" exists with suggestion: "running naked in the park"

    When I fill in "mindapple" with "shooting"
    And I press "Find"
    Then I should not see "wrestling with bears in the park"
    And I should not see "running naked in the park"
    And I should not see "eating ice cream"
    And I should see "Sorry, it seems that we can't find what you are looking for."
