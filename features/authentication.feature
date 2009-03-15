@trac_0001
Feature: Logging in
  In order to access my profile
  As a user
  I want to login with my details| do

  Scenario: Try to login with non existing account
    Given I am on the login page
    When I fill in "Login" with "jdoe"
    And I fill in "Password" with "letmein"
    And I press "Log in"
    Then I should see "Couldn't log you in as 'jdoe'"

  Scenario: Use wrong password
    Given I am on the login page
    And my username is "anna" and my password is "frooble"
    When I fill in "Login" with "anna"
    And I fill in "Password" with "letmein"
    And I press "Log in"
    Then I should see "Couldn't log you in as 'anna'"

  Scenario: Log in as regular user
    Given I am on the login page
    And my username is "anna" and my password is "frooble"
    When I fill in "Login" with "anna"
    And I fill in "Password" with "frooble"
    And I press "Log in"
    Then I should see "anna"
    And I should see a link to my profile
