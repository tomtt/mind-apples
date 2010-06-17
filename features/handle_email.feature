@pivotal_2034096 

Feature: Handle taken email gracefully
  In order to not confuse users
  As the evil overlord
  I want users to receive an 'email taken' message and not get caught in a strange session loop

  Scenario: Filling in your five a day with already taken email
    Given person exists with email: "lucy@example.com"
    When I go to the "take the test" page
    And I fill in "Don't go! Leave your e-mail" with "lucy@example.com"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should see "That e-mail address is already taken. Please choose again."

  Scenario: Editing your five with already taken email
    Given person exists with email: "lucy@example.com"
    And I have a personal page
    And my login is "autogen_anna"
    And my email is "anna@example.com"
    And my password is "apples"
    And my braindump is "I love Mindapples"
    When I log in
    And I follow "edit"
    And I fill in "Don't go! Leave your e-mail" with "lucy@example.com"
    And I check "person_policy_checked"
    And I press "Submit"
    And I should not see "Thank you for sharing your mindapples."
    Then I should see "That e-mail address is already taken. Please choose again."

  Scenario: Editing your five with already taken email
    Given I have a personal page
    And my login is "autogen_anna"
    And my email is "anna@example.com"
    And my password is "apples"
    And my braindump is "I love Mindapples"
    When I log in
    And I follow "edit"
    And I fill in "Don't go! Leave your e-mail" with "lucy@example.com"
    And I fill in "Be proud. What's your name? (very optional)" with "Anna Karenina"
    And I check "person_policy_checked"
    And I press "Submit"
    And I should not see "Thank you for sharing your mindapples."
    Then I should see "That e-mail address is already taken. Please choose again."

  Scenario: Editing your five with already taken email
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I press "Submit"
    Then I follow "edit"
    And I fill in "Join us. Choose a username for your Mindapples account" with "banana_man"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I check "person_policy_checked"
    And I fill in "Don't go! Leave your e-mail" with ""
    And I press "Submit"
    And I should not see "Thank you for sharing your mindapples."
    Then I should see "That email address is already taken. Please choose again."
    Then I should see "We need your email address to create your account."

  Scenario: Editing your five with validate email format
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I press "Submit"
    Then I follow "edit"
    And I fill in "Join us. Choose a username for your Mindapples account" with "banana_man"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I check "person_policy_checked"
    And I fill in "Don't go! Leave your e-mail" with "asas"
    And I press "Submit"
    And I should not see "Thank you for sharing your mindapples."
    Then I should see "That doesn't look like a valid e-mail address. Please try again."
    Then I should not see "We need your email address to create your account."
    Then I should not see "That email address is already taken. Please choose again."

