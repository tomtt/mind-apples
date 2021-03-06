@pivotal_3773892

Feature:  As a social butterfly/little miss bashful I have to fill in email/password if fill in username
  In order to properly fill forms
  As user
  I want validate forms input
  
  Scenario: As a social butterfly I don't have to fill in email if I don't fill in username
    When I go to the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "banana_man"
    When I press "Submit"
    Then I should not see "My five a day"

  Scenario: As a social butterfly I must fill in email/password confirmation if I fill in username
    When I go to the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "banana_man"
    And I fill in "Password" with "secretsuper"
    And I fill in "Confirm password" with "secretsuper"
    When I press "Submit"
    Then I should not see "My five a day"
    And I should see "We need your email address to create your account."

  Scenario: As a social butterfly/little miss bashful I must fill in password confirmation if I fill in username
    When I go to the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "banana_man"
    And I fill in "Email" with "andy@example.com"
    When I press "Submit"
    Then I should not see "My five a day"
    And I should see "Please choose a valid password (minimum is 4 characters)"

  Scenario: As a little miss bashful I don't have to fill in email if I don't fill in username
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Go"
    Then the "Yes yes, of course I accept the Terms & Conditions" checkbox should not be checked

    When I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "banana_man"
    And I press "Submit"
    Then I should not see "My five a day"

  #Scenario: As a little miss bashful I must fill in email/password confirmation if I fill in username
    #When I go to the homepage
    #And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    #And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    #And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    #And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    #And I press "Go"

    #And I check "person_policy_checked"
    #And I press "Submit"
    #And I fill in "Choose a username" with "banana_man"
    #And I fill in "Password" with "secretsuper"
    #And I fill in "Confirm password" with "secretsuper"
    #When I press "Submit"
    #Then I should not see "My five a day"
    #And I should see "We need your email address to create your account."

  Scenario: I'm not able save short password on edit page if I fill in username
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Go"

    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "banana_man"
    And I fill in "Password" with "s"
    And I fill in "Confirm password" with "s"
    And I fill in "Email" with "andy@example.com"
    And I press "Submit"
    Then I should see "Please choose a valid password (minimum is 4 characters)"
    And I should not see "My five a day"

  Scenario: I'm not able save already existed login
    Given user exists with login: "banana_man"
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I press "Go"

    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "banana_man"
    And I fill in "Password" with "supersecret"
    And I fill in "Confirm password" with "supersecret"
    And I fill in "Email" with "andy@example.com"
    When I press "Submit"
    Then I should see "That username has already been taken. Please choose again."
    And I should not see "My five a day"

  Scenario: Person try log in with wrong login or password
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "I love Mindapples"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "antisosocial"
    And I press "Log in"
    Then I should see "Sorry, we don't recognise that username and password combination. Please try again."

  Scenario: Fields has to be populated if some erros happend after pressing submit button
    Given I have a personal page
    And I am logged in
    When I go to my edit page
    And I fill in "Username" with "andyyy"
    And I fill in "Password" with "wibble"
    And I fill in "Email address. Leave your e-mail and we'll post you your mindapples. (never made public)" with "andy@example.com"
    And I press "Submit"
    Then I should see "Oh dear, there was a problem:"
    And I should see a "person[email]" text field containing "andy@example.com"
