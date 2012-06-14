@pivotal_3772759

Feature: Mindapples Home Page
  In order to give the user a starting point
  As a user
  I want to see the Mindapples home page

  Scenario: As a curious cat I can see the 5 a day section
    When I go to the homepage
    Then I should see "What are your mindapples?"
    And I should see a "person[mindapples_attributes][0][suggestion]" text field
    And I should see a "person[mindapples_attributes][1][suggestion]" text field
    And I should see a "person[mindapples_attributes][2][suggestion]" text field
    And I should see a "person[mindapples_attributes][4][suggestion]" text field
    And I should see a "go.png" image button

  Scenario: As a logged in user I can't see the 5 a day section
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    And I go to the homepage

    Then I should not see "What are your mindapples?"
    And I should not see a "person[mindapples_attributes][0][suggestion]" text field
    And I should not see a "person[mindapples_attributes][1][suggestion]" text field
    And I should not see a "person[mindapples_attributes][2][suggestion]" text field
    And I should not see a "person[mindapples_attributes][4][suggestion]" text field
