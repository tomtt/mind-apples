@committed

Feature: Setting login
  In order to have a more personalized page
  As a social butterfly
  I want to pick my nickname for my page

  Scenario: Picking a nickname
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I press "Submit"
    And I fill in "Pick a nickname" with "spotty"
    And I press "Submit"
    And I follow "Edit"    
    Then I should not see a "person[login]" text field
    And I should be on "/person/spotty/edit"
