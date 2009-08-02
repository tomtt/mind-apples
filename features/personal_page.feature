Feature: Personal page
  Personal page

  Background:
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Login"

  Scenario: Person logs in and sees his page
    Then I should see "Mindapples rocks"

  Scenario: Person logs in and edits his page
    When I follow "edit"
    Then I should see a "Brain dump" text area with "Mindapples rocks"
    When I fill in "Brain dump" with "Mindapples really rocks"
    And I press "Submit"
    Then I should see "Mindapples really rocks"
