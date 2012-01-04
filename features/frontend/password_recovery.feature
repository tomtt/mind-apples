@pivotal_1292289

Feature: Setting a password
  In order to be able to edit my page
  As a social butterfly
  I want to be able to set a password that I can use to edit my page

  Scenario: Reseting a password through an email
    Given I have access to the inbox of "lucy@example.com"
    And I have a personal page
    And my braindump is "I heart mindapples"
    And my login is "lucy"
    And my email is "lucy@example.com"
    When I go to the login page
    And I fill in "Enter your email to receive instructions on how to set your password" with "lucy@example.com"
    And I press "Send email"

    Then I should receive 1 emails
    When I open the email with subject "Setting your Mindapples password"
    And I click the first link in the email

    And I fill in "Password" with "mynewpassword"
    And I fill in "Password confirmation" with "mynewpassword"
    And I press "Give me that password and log me in"

    Then I should see "Password successfully updated"
    And I should see a "person[braindump]" text area containing "I heart mindapples"

  Scenario: Atempting to recover a password for a non-existent user
    Given I have access to the inbox of "lucy@example.com"

    When I go to the login page
    And I fill in "Enter your email to receive instructions on how to set your password" with "lucy@example.com"
    And I press "Send email"

    Then I should receive no emails
    And I should see "No user was found with that email address"
    And I should see "Enter your email to receive instructions on how to set your password"
