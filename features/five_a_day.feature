@committed
@pivotal_1291985
@pivotal_1292084
@pivotal_1292096
@pivotal_1292172

Feature: Asking for five a day
  In order to gather suggestions
  As the evil overlord
  I want respondents to enter suggestions

  Scenario: Social Butterfly fills in the survey
    Given I have access to the inbox of "andy@example.com"
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I fill in "Brain dump" with "Amazing stuff"
    And I fill in "Health check" with "2"
    And I choose "Male"
    And I select "35-44" from "person[age]"
    And I fill in "Passport control" with "UK"
    And I fill in "Your thing" with "social guru"
    And I fill in "Be proud" with "Andy Gibson"
    And I fill in "Don't go! Leave your e-mail" with "andy@example.com"
    And I press "Submit"
    # Then I should see "Thank you"
    And I should see a "person[mindapples_attributes][0][suggestion]" text field containing "Playing the piano"
    And I should see a "person[mindapples_attributes][1][suggestion]" text field containing "Being in nature"
    And I should see a "person[mindapples_attributes][2][suggestion]" text field containing "Interesting conversation"
    And I should see a "person[mindapples_attributes][4][suggestion]" text field containing "Tidying and filing"
    And I should see a "person[braindump]" text area containing "Amazing stuff"
    And I should see a "person[health_check]" text field containing "2"
    And the "Male" checkbox should be checked
    And I should see an "Age" select field with "35-44" selected
    And I should see a "person[location]" text field containing "UK"
    And I should see a "person[occupation]" text field containing "social guru"
    And I should see a "person[name]" text field containing "Andy Gibson"
    And I should see a "person[email]" text field containing "andy@example.com"

    And I should receive an email
    When I open the email
    Then I should see "Your Mindapples" in the email subject
