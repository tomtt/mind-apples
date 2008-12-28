Feature: Logging in
  In order to access my profile
  As a user
  I want to login with my details| do

  Scenario: Use wrong password
    Given I am on the login page
    When I fill in "Login" with "jdoe"
    And I fill in "Password" with "letmein"
    And I press "Log in"
    Then I should see "Login"
