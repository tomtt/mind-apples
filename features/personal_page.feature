@pivotal_1292369

Feature: Personal page
  Personal page

  Background:
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"

  Scenario: Person logs in and sees his page
    Then I should see "Mindapples rocks"
    And I should see "Welcome back 'gandy'"
    And I should see "gandy's page on Mindapples"

  Scenario: Person follows the link to his page
    When I follow "About us"
    And I follow "Your mindapples page"
    Then I should see "Mindapples rocks"

  Scenario: Another person logs in while somebody is already logged in
    Given I have a personal page
    And my login is "anna"
    And my password is "apples"
    And my braindump is "I love Mindapples"
    When I log in
    And I follow "Your mindapples"
    Then I should see "I love Mindapples"

  Scenario: A new survey is filled in while somebody is already logged in
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I press "Submit"
    And I follow "Your mindapples"
    Then I should see "Playing the piano"

  Scenario: Person edits his page
    When I follow "Edit"
    Then I should see a "person[braindump]" text area containing "Mindapples rocks"
    When I fill in "Brain dump" with "Mindapples really rocks"
    And I press "Submit"
    Then I should see "Mindapples really rocks"

  Scenario: Person sets his name
    When I follow "Edit"
    And I fill in "Be proud. What's your name" with "Bob the Builder"
    And I press "Submit"
    Then I should see "Bob the Builder's page on Mindapples"

  Scenario: A hacker tries to edit another person's page
    Given I have a personal page
    And my login is "hacker"
    And my password is "cybersecret"
    And I log in
    And I go to "/person/gandy/edit"
    Then I should see "You do not have permission to edit this page"

  Scenario: Email does not appear on personal page
    Given I have a personal page
    And my login is "hacker"
    And my password is "cybersecret"
    And I log in
    And I go to "/person/gandy"
    Then I should not see "gandy@example.com"

  Scenario: Person views his own page when not logged in
    When I follow "Log out"
    And I go to "/person/gandy"
    Then I should see "Mindapples rocks"

  Scenario: Person edits his page when not logged in
    When I follow "Log out"
    And I go to "/person/gandy"
    And I follow "edit"
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    Then I should see a "person[braindump]" text area containing "Mindapples rocks"
