@pivotal_3958507
@pivotal_4019289

Feature: Meaningful error messages
  In order to get proper error messages
  As a user
  I want to see meaningful error messages

  Scenario: "As a social butterfly I should see meaningful error message for Terms & Conditions"
    Given I am on the "take the test" page
    When I press "Submit"
    Then I should see "Please keep our lawyers happy by ticking the box to say you agree to our terms and conditions."
    And I should not see "1 error prohibited this person from being saved"
    And I should not see "There were problems with the following fields:"
    And I should not see "Policy checked Please accept the Terms & Conditions"
    And I should see "Oh dear, there was a problem"

  Scenario: "As a social butterfly I should see meaningful error messages for email and password"
    Given I am on the "take the test" page
    And I check "person_policy_checked"
    When I press "Submit"
    And I fill in "Choose a username" with "gandy"
    When I press "Submit"
    Then I should not see "There were problems with the following fields:"
    And I should not see "Email We need your email address to create your account."
    And I should not see "Password Please choose a valid password (minimum is 4 characters)"
    And I should not see "Password Looks like your password and confirmation don't match."
    And I should not see "Password confirmation Please choose a valid password (minimum is 4 characters)"
    And I should not see "Looks like your password and confirmation don't match."
    And I should see "Oh dear, there were 2 problems:"
    And I should see "We need your email address to create your account."
    And I should see "Please choose a valid password (minimum is 4 characters)"

  Scenario: "As a social butterfly I should see meaningful error messages for email taken error"
    Given a person exists with email: "mindapple@min.com"
    And I am on the "take the test" page
    And I check "person_policy_checked"
    When I press "Submit"
    And I fill in "Choose a username" with "gandy"
    And I fill in "Email" with "mindapple@min.com"
    When I press "Submit"
    Then I should see "That e-mail address is already taken. Please choose again."
    And I should not see "Email That e-mail address is already taken. Please choose again."

  Scenario: "As a social butterfly I should see meaningful error messages for password confirmation"
    Given I am on the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "gandy"
    And I fill in "Email" with "mindapple@min.com"
    And I fill in "Password" with "somesecretpassword"
    And I fill in "Confirm password" with ""
    When I press "Submit"
    Then I should not see "Please choose a valid password (minimum is 4 characters)"
    And I should see "Looks like your password and confirmation don't match."

  Scenario: "As a social butterfly I should see meaningful error messages for password confirmation"
    Given I am on the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "gandy"
    And I fill in "Email" with "mindapple@min.com"
    And I fill in "Password" with "somesecretpassword"
    And I fill in "Confirm password" with "something different"
    When I press "Submit"
    Then I should not see "Please choose a valid password (minimum is 4 characters)"
    And I should see "Looks like your password and confirmation don't match."

  Scenario: "As a social butterfly I should see meaningful error messages for password confirmation"
    Given I am on the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "gandy"
    And I fill in "Email" with "mindapple@min.com"
    And I fill in "Password" with ""
    And I fill in "Confirm password" with ""
    When I press "Submit"
    Then I should see "Please choose a valid password (minimum is 4 characters)"
    And I should not see "Looks like your password and confirmation don't match."
