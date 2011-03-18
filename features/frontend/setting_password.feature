@pivotal_1292289

Feature: Setting a password
  In order to be able to edit my page
  As a social butterfly
  I want to be able to set a password that I can use to edit my page

  Scenario: Setting a password from the personal page editing form
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I press "Go"
    And I fill in "person[password]" with "opensesame"
    And I fill in "person[password_confirmation]" with "opensesame"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should see "My five a day"
    And I should see "Thanks for sharing your mindapples!"

  Scenario: Setting a password through an email
    Given I have access to the inbox of "lucy@example.com"
    And I have a personal page
    And my braindump is "I heart mindapples"
    And my login is "lucy"
    And my email is "lucy@example.com"
    And I go to the login page
    And I fill in "Enter your email to receive instructions on how to set your password" with "lucy@example.com"
    And I press "Send email"

    Then I should receive 1 emails
    When I open the email with subject "Setting your Mindapples password"
    And I click the first link in the email

    And I fill in "Password" with "mynewpassword"
    And I fill in "Password confirmation" with "mynewpassword"
    And I press "Give me that password and log me in"

    Then I should see a "person[braindump]" text area containing "I heart mindapples"

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
