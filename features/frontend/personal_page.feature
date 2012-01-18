@pivotal_1292369

Feature: Personal page
  Personal page

  Scenario: Person logs in and sees his page and the page is public 
    Given a user exists with login: "butterfly", password: "sosocial", password_confirmation: "sosocial"
    And a person "SocialButterfly" exists with public_profile: true, user: that user, braindump: "Mindapples rocks", one_line_bio: "Lots of stuff about me"
    When I go to the login page
    And I fill in "Login" with "butterfly"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    Then I should see "My five a day"
    And I should not see a link to "go"
    And I should not see "and pick your 5-a-day. "
    And I should see "Lots of stuff about me"

  Scenario: Person logs in using his email and sees his page
    Given a user exists with login: "butterfly", email: "social@example.com", password: "sosocial", password_confirmation: "sosocial"
    And a person "SocialButterfly" exists with public_profile: true, user: that user, braindump: "Mindapples rocks", one_line_bio: "Lots of stuff about me"
    When I go to the login page
    And I fill in "Login" with "social@example.com"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    Then I should see "My five a day"
    And I should not see a link to "go"
    And I should not see "and pick your 5-a-day. "
    And I should see "Lots of stuff about me"

  Scenario: Person logs in and sees his page and the page is not public
    Given a user exists with login: "butterfly", password: "sosocial", password_confirmation: "sosocial"
    And a person "SocialButterfly" exists with public_profile: false, user: that user, braindump: "Mindapples rocks", one_line_bio: "Lots of stuff about me"
    When I go to the login page
    And I fill in "Login" with "butterfly"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    And I should see "My five a day"
    Then I should not see a link to "go"
    And I should not see "and pick your 5-a-day. "

  Scenario: Person views another's page and the page is public
    Given a user exists with login: "butterfly"
    And a person "SocialButterfly" exists with public_profile: true, user: that user
    When I go to "/person/butterfly"
    And I should see a link to "go"
    And I should not see "and pick your 5-a-day. "
    And I should see "What do you do to look after your mind?"
    And I should not see "You don't have permission to see this page"

  Scenario: Person views another's page and the page is not public
    Given a user exists with login: "bashful"
    And a person "Miss Bashful" exists with public_profile: false, user: that user
    When I go to "/person/bashful"
    Then I should not see "Mindapples rocks"
    And I should not see a link to "go"
    And I should see "You don't have permission to see this page"

  Scenario: Person logs in and sees his page
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    Then I should see "My five a day"
    And I should not see a link to "go"
    And I should not see "and pick your 5-a-day. "
  
  Scenario: Person views his own page when not logged in
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to "/person/gandy"
    Then I should see a link to "go"
    And I should not see "and pick your 5-a-day. "
    And I should see "What do you do to look after your mind?"

  Scenario: Person follows the link to his page
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    When I follow "About us"
    And I follow "Me"
    Then I should see "My five a day"

  Scenario: Another person logs in while somebody is already logged in
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    Given I have a personal page
    And my login is "anna"
    And my password is "apples"
    When I log in
    And I follow "Me"

  Scenario: Trying to edit another's page while logged in will take me to the homepage
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    And a user exists with login: "butterfly"
    And a person "SocialButterfly" exists with public_profile: true, user: that user
    When I go to "butterfly" edit page
    Then I should be on the homepage
    And I should see "You don't have permission to edit this page"
    
  Scenario: A new survey is filled in while somebody is already logged in
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    When I go to the "take the test" page
    Then I should see "You're already logged in as 'gandy'."
    When I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "Choose a username" with "new_user"
    And I fill in "Email" with "new@example.com"
    And I fill in "Password" with "new_secret"
    And I fill in "Confirm password" with "new_secret"
    And I press "Submit"
    Then I should see "Playing the piano"

  Scenario: Person edits his page
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    When I follow "Edit"
    Then I should see a "person[braindump]" text area containing "Mindapples rocks"

  Scenario: Person sets his name
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    When I follow "Edit"
    And I fill in "Your name" with "Bob the Builder"
    And I press "Submit"
    Then I should see "My five a day"
    And I should see "Bob the Builder"

  Scenario: Person sets his new password
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    When I follow "Edit"
    And I fill in "Password" with "secretsuper"
    And I fill in "Confirm password" with "secretsuper"
    And I press "Submit"
    Then I should see "Thank you for updating your Mindapples page."
    When I follow "Edit"
    Then I should not see "You do not have permission to edit this page"

  Scenario: Person edit his policy
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    When I follow "Edit"
    And I uncheck "person_policy_checked"
    And I press "Submit"
    Then I should not see "Thank you for updating your Mindapples page."
    And I should see "Please keep our lawyers happy by ticking the box to say you agree to our terms and conditions."

  Scenario: A hacker tries to edit another person's page
    Given a user exists with login: "gandy"
    And a person exists with public_profile: true, user: that user
    Given I have a personal page
    And my login is "hacker"
    And my password is "cybersecret"
    When I log in
    And I go to "/person/gandy/edit"
    Then I should see "You don't have permission to edit this page"

  Scenario: Email does not appear on personal page
    Given a user exists with login: "gandy"
    And a person exists with public_profile: true, user: that user, email: "gandy@example.com"
    Given I have a personal page
    And my login is "hacker"
    And my password is "cybersecret"
    When I log in
    And I go to "/person/gandy"
    Then I should not see "gandy@example.com"

  Scenario: Person edits his page when not logged in
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    And I follow "Edit"
    Then I should see a "person[braindump]" text area containing "Mindapples rocks"

  Scenario: Password is not mandatory if person is on edit page
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    And I am logged in
    And I am on my edit page
    When I press "Submit"
    Then I should see "Thank you for updating your Mindapples page."

  Scenario: Anonymous user visiting his page can edit it
    Given a person exists with page_code: "sadfkjlhasfyq3f", email: "andy@example.com"
    When I go to "/person/_sadfkjlhasfyq3f"
    Then I should see "Edit" link with "/person/_sadfkjlhasfyq3f/edit" url
    When I follow "Edit"
    Then I should see "Edit your page"
    And the "Email" field should contain "andy@example.com"
