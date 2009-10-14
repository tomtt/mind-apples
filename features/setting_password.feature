@committed

Feature: Setting a password
  In order to be able to edit my page
  As a social butterfly
  I want to be able to set a password that I can use to edit my page

  Scenario: Setting a password
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I press "Submit"
    And I fill in "person[password]" with "opensesame"
    And I fill in "person[password_confirmation]" with "opensesame"
    And I press "Submit"
    Then I should be on "/person/spotty/edit"
