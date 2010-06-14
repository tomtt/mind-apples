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

  Scenario: Person logs in and sees his page and the page is public 
    Given a person "SocialButterfly" exists with public_profile: true, login: "butterfly", password: "sosocial", password_confirmation: "sosocial", braindump: "Mindapples rocks"
    When I follow "Log out"
    When I go to the login page
    And I fill in "Login" with "butterfly"
    And I fill in "Password" with "sosocial"
    And I press "Log in"

    Then I should see "Mindapples rocks"
    # And I should see "Welcome back 'butterfly'"
    And I should see "butterfly's page on Mindapples"
    Then I should not see a link to "Take the Mindapples test"
    And I should not see "and pick your 5-a-day. "

  Scenario: Person logs in and sees his page and the page is not public
    Given a person "SocialButterfly" exists with public_profile: false, login: "butterfly", password: "sosocial", password_confirmation: "sosocial", braindump: "Mindapples rocks"
    When I follow "Log out"
    When I go to the login page
    And I fill in "Login" with "butterfly"
    And I fill in "Password" with "sosocial"
    And I press "Log in"

    Then I should see "Mindapples rocks"
    # And I should see "Welcome back 'butterfly'"
    And I should see "butterfly's page on Mindapples"
    Then I should not see a link to "Take the Mindapples test"
    And I should not see "and pick your 5-a-day. "

  Scenario: Person views another's page and the page is public
    Given a person "SocialButterfly" exists with public_profile: true, login: "butterfly"
    When I follow "Log out"
    And I go to "/person/butterfly"
    And I should see a link to "Take the Mindapples test"
    And I should see "and pick your 5-a-day. "
    And I should not see "You don't have permission to see this page"

  Scenario: Person views another's page and the page is not public
    Given a person "Miss Bashful" exists with public_profile: false, login: "bashful"
    When I follow "Log out"
    And I go to "/person/bashful"
    Then I should not see "Mindapples rocks"
    And I should not see a link to "Take the Mindapples test"
    And I should see "You don't have permission to see this page"

  Scenario: Person logs in and sees his page
    Then I should see "Mindapples rocks"
    # And I should see "Welcome back 'gandy'"
    And I should see "gandy's page on Mindapples"
    Then I should not see a link to "Take the Mindapples test"
    Then I should not see "and pick your 5-a-day. "
  
  Scenario: Person views his own page when not logged in
    When I follow "Log out"
    And I go to "/person/gandy"
    Then I should see "Mindapples rocks"
    Then I should see a link to "Take the Mindapples test"
    Then I should see "and pick your 5-a-day. "

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

	@permission_bug
  Scenario: Trying to edit another's page while logged in will take me to the homepage
    Given I have a personal page
	And a person "SocialButterfly" exists with public_profile: true, login: "butterfly"
    And my login is "anna"
    And my password is "apples"
    And my braindump is "I love Mindapples"
    When I log in
	And I go to "butterfly" edit page
	Then I should be on the homepage
		
  Scenario: A new survey is filled in while somebody is already logged in
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I check "person_policy_checked"
    And I press "Submit"
    And I follow "Your mindapples"
    Then I should see "Playing the piano"

  Scenario: Person edits his page
    When I follow "Edit"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    Then I should see a "person[braindump]" text area containing "Mindapples rocks"
    When I fill in "Brain dump" with "Mindapples really rocks"
    And I press "Submit"
    Then I should see "Mindapples really rocks"

  Scenario: Person sets his name
    When I follow "Edit"
    And I fill in "Be proud. What's your name" with "Bob the Builder"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I press "Submit"
    Then I should see "Bob the Builder's page on Mindapples"

  Scenario: Person sets his new password
    When I follow "Edit"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I press "Submit"
    Then I should see "Thank you for updating your Mindapples page."
    Then I follow "Edit"
    And I should not see "You do not have permission to edit this page"

  Scenario: Person edit his policy
    When I follow "Edit"
    And I uncheck "person_policy_checked"
    And I fill in "person[password]" with "secretsuper"
    And I fill in "person[password_confirmation]" with "secretsuper"
    And I press "Submit"
    Then I should not see "Thank you for updating your Mindapples page."
    And I should see "Please accept the Terms & Conditions"

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

  Scenario: Person edits his page when not logged in
    When I follow "Log out"	
    And I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    And I follow "Edit"
    Then I should see a "person[braindump]" text area containing "Mindapples rocks"
