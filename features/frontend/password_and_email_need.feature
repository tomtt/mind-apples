@pivotal_3773892

Feature:  As a social butterfly/little miss bashful I have to fill in email/password if fill in username
  In order to properly fill forms
  As user
  I want validate forms input
  
  Scenario: As a social butterfly I don't have to fill in email if I don't fill in username
    When I go to the "take the test" page

    And I fill in "Join us. Choose a username." with "banana_man"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should not see "My five a day"

  Scenario: As a social butterfl I must fill in email/password confirmation if I fill in username
    When I go to the "take the test" page

    And I fill in "Join us. Choose a username." with "banana_man"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should not see "My five a day"

  Scenario: As a social butterfly/little miss bashful I must fill in email/password confirmation if I fill in username
    When I go to the "take the test" page

    And I fill in "Join us. Choose a username." with "banana_man"
    And I fill in "E-mail us" with "andy@example.com"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should not see "My five a day"

  Scenario: As a little miss bashful I don't have to fill in email if I don't fill in username
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Go"
    And the "Yes yes, of course I accept the Terms & Conditions" checkbox should not be checked

    And I fill in "Join us. Choose a username." with "banana_man"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should not see "My five a day"

  Scenario: As a little miss bashful I must fill in email/password confirmation if I fill in username
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Go"

    And I fill in "Join us. Choose a username." with "banana_man"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should not see "My five a day"
    And I should see "We need your email address to create your account."

  Scenario: I'm not able save short password on edit page if I fill in username
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Go"

    And I fill in "Join us. Choose a username." with "banana_man"
    And I fill in "person[password]" with "s"
    And I fill in "person[password_confirmation]" with "s"
    And I fill in "E-mail us" with "andy@example.com"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should see "Please choose a valid password (minimum is 4 characters)"
    Then I should not see "My five a day"

  Scenario: I'm not able save already existed login
    Given person exists with login: "banana_man"
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I press "Go"

    And I fill in "Join us. Choose a username." with "banana_man"
    And I fill in "person[password]" with "supersecret"
    And I fill in "person[password_confirmation]" with "supersecret"
    And I fill in "E-mail us" with "andy@example.com"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should see "That username has already been taken. Please choose again."
    Then I should not see "My five a day"

  Scenario: Person try log in with wrong login or password
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "I love Mindapples"
    And I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "antisosocial"
    And I press "Log in"
    Then I should see "Sorry, we don't recognise that username and password combination. Please try again."

  Scenario: Fields has to be populated if some erros happend after pressing submit button
    Given I have a personal page
    And I am on my edit page
    And I am logged in
    And I fill in "Join us. Choose a username" with "andyyy"
    And I fill in "E-mail us" with "andy@example.com"
    And I press "Submit"
    Then I should see "Oh dear, there was a problem:"
    And I should see a "person[email]" text field containing "andy@example.com"
