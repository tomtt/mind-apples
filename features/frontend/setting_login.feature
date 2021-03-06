@committed

Feature: Setting login
  In order to have a more personalized page
  As a social butterfly
  I want to pick my nickname for my page

  Scenario: Picking a nickname from the "take the test" page
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "spotty"
    And I fill in "Email" with "apple@mind.com"
    And I fill in "Password" with "bigsecret"
    And I fill in "Confirm password" with "bigsecret"
    And I press "Submit"
    And I follow "Edit"
    Then I should not see "Join us. Choose a username to claim your page"
    # Then I should not see a "person[login]" text field
    And I should be on "/person/spotty/edit"

  Scenario: Trying to set login to a value that includes disallowed characters.
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "invalid.username"
    And I fill in "Email" with "apple@mind.com"
    And I fill in "Password" with "bigsecret"
    And I fill in "Confirm password" with "bigsecret"
    And I press "Submit"
    Then I should see "Sorry, usernames can only contain letters, numbers, dash and underscore. Please choose again."
    And I should see a "person[user_attributes][login]" text field

  Scenario: Trying to set login to a value that starts with an underscore from the "take the test" page
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "_pluk"
    And I fill in "Email" with "apple@mind.com"
    And I fill in "Password" with "bigsecret"
    And I fill in "Confirm password" with "bigsecret"
    When I press "Submit"
    Then I should see "Sorry, usernames cannot begin with an underscore. Please choose again."
    And I should see a "person[user_attributes][login]" text field
