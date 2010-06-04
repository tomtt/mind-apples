@committed
@pivotal_1291985
@pivotal_1292084
@pivotal_1292096
@pivotal_1292172
@pivotal_3771421

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
    And I press "Submit"
    Then I should see "Here are their suggestions for good things to do to keep your mind healthy"
    And I should see "Wrestling with bears"
    And I should see "Welcome back"
    And I should not see "Welcome back '"

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
    And I fill in "Passport control" with "UK"
    And I fill in "Your thing" with "social guru"
    And I fill in "Be proud" with "Andy Gibson"
    And I fill in "Don't go! Leave your e-mail" with "andy@example.com"
    And I choose "person_public_profile_true"
    And I check "policy"
    And I press "Submit"
    Then I should see "Here are their suggestions for good things to do to keep your mind healthy"
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

    And I should receive an email
    When I open the email
    Then I should see "Your Mindapples" in the email subject

  Scenario: Filling in the test incorrectly from the take the test page
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Slithering with snakes"
    And I fill in "person[password_confirmation]" with "shhh"
    And I press "Submit"
    Then I should see "Password doesn't match confirmation"
    And I should see a "person[password_confirmation]" password field containing "shhh"
  @policy
  Scenario: Filling in the test correctly from the take the test page but without agreeing the policy
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Slithering with snakes"
    And I press "Submit"
    Then I should see "Please keep our laywers happy by ticking the box to say you agree to our terms and conditions. Otherwise they'll worry."
    And I should see "Did you accept the Terms & Conditions?"

  Scenario: Everybody can follow link to terms page from test page
    When I go to the "take the test" page
    And I follow "Terms & Conditions"
    Then I should see "govern your access to and use of"
   