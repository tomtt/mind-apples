@committed
@pivotal_1291985
@pivotal_1292084
@pivotal_1292096
@pivotal_1292172
@pivotal_3771421
@pivotal_3773666
@pivotal_4135609

Feature: Asking for five a day
  In order to gather suggestions
  As the evil overlord
  I want respondents to enter suggestions

  Scenario: Filling in your five a day from the form on the front page
    When I go to the homepage
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Wrestling with bears"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Go"
    Then I should see "Yes yes, of course I accept the Terms & Conditions"
    # And the "Join us. Choose a username." field should not contain "autogen"
    And I should see a "person[mindapples_attributes][0][suggestion]" text field containing "Wrestling with bears"
    And I should see a "person[mindapples_attributes][1][suggestion]" text field containing "Being in nature"
    And I should see a "person[mindapples_attributes][2][suggestion]" text field containing "Interesting conversation"
    And I should see a "person[mindapples_attributes][4][suggestion]" text field containing "Tidying and filing"

  Scenario: Social Butterfly fills in the survey from the test page
    Given I have access to the inbox of "andy@example.com"
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I fill in "Brain dump" with "Amazing stuff"
    And I choose "person_health_check_2"
    And I choose "Male"
    And I select "35-44" from "person[age]"
    And I fill in "Passport" with "UK"
    And I fill in "Your thing" with "social guru"
    And I fill in "Your name" with "Andy Gibson"
    And I fill in "Email address. Leave your e-mail" with "andy@example.com"
    And I check "person_email_opt_in"
    And I check "person_policy_checked"
    And I press "Submit"

    Then I should be on the "register" page for person "Andy Gibson"
    And I should see "Thanks for sharing your mindapples"
    And the "Email" field should contain "andy@example.com"
    And the "Your name" field should contain "Andy Gibson"
    And I fill in "Username" with "AndyG"
    And I upload the picture "smile2.jpg"
    And I fill in "person[one_line_bio]" with "This is my autobiography and bizzle."
    And I fill in "Password" with "Secret"
    And I fill in "Confirm password" with "Secret"
    And I choose "person_public_profile_true"
    And I press "Submit"
        
    Then I should see "My five a day"
    And I should see "Thanks for registering your Mindapples page"
    And I should see "Being in nature"
    When I follow "Edit"
    Then I should see a "person[mindapples_attributes][0][suggestion]" text field containing "Playing the piano"
    And I should see a "person[mindapples_attributes][1][suggestion]" text field containing "Being in nature"
    And I should see a "person[mindapples_attributes][2][suggestion]" text field containing "Interesting conversation"
    And I should see a "person[mindapples_attributes][4][suggestion]" text field containing "Tidying and filing"
    And I should see a "person[braindump]" text area containing "Amazing stuff"
    And "2" should be selected from the "person[health_check]" options
    And the "Male" checkbox should be checked
    And I should see an "Age" select field with "35-44" selected
    And I should see a "person[location]" text field containing "UK"
    And I should see a "person[occupation]" text field containing "social guru"
    And I should see a "person[name]" text field containing "Andy Gibson"
    And I should see a "person[email]" text field containing "andy@example.com"
    And the "A little about you... (Optional)" field should contain "This is my autobiography and bizzle."

    And I should receive an email
    When I open the email
    Then in the email subject I should see "Your Mindapples"

  Scenario: Filling in the test incorrectly from the take the test page
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Slithering with snakes"
    And I check "person_policy_checked"
    And I press "Submit"
    And I fill in "person[password_confirmation]" with "shhh"
    And I press "Submit"
    Then I should see "Looks like your password and confirmation don't match"
    And I should not see a "person[password_confirmation]" password field containing "shhh"

  Scenario: Filling in the test correctly from the take the test page but without agreeing the policy
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Slithering with snakes"
    And I press "Submit"
    Then I should see "Please keep our lawyers happy by ticking the box to say you agree to our terms and conditions."

  Scenario: Everybody can follow link to terms page from test page
    When I go to the "take the test" page
    And the "Yes yes, of course I accept the Terms & Conditions" checkbox should not be checked
    And I follow "Terms & Conditions"
    Then I should see "our Web Site at mindapples.org you signify"
