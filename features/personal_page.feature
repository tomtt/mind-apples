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
    And I press "Log in"

  Scenario: Person logs in and sees his page
    Then I should see "Mindapples rocks"

  Scenario: Another person logs in while somebody is already logged in
    Given I have a personal page
    And my login is "anna"
    And my password is "apples"
    And my braindump is "I love Mindapples"
    When I log in
    And I follow "Your page"
    Then I should see "I love Mindapples"

  Scenario: A new survey is filled in while somebody is already logged in
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I press "Submit"
    And I follow "Your page"
    Then I should see "Playing the piano"

  Scenario: Person logs in and edits his page
    When I follow "edit"
    Then I should see a "Brain dump" text area with "Mindapples rocks"
    When I fill in "Brain dump" with "Mindapples really rocks"
    And I press "Submit"
    Then I should see "Mindapples really rocks"