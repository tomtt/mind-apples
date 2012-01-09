@pivotal_1292322

Feature: Original responders can claim their page
  In order to offer something nice to people who have already filled in the survey
  As the evil overlord
  I want the survey monkey respondents to get an email that they can use to gain exclusive access to their mindapples page

  Scenario: Responder is sent an email which she uses to claim her page
    Given a person "mindy" exists with email: "mindy@example.com", respondent_id: 1475
    And I have access to the inbox of "mindy@example.com"
    When the person "mindy" is sent instructions on how to claim her page
    Then I should receive an email
    When I open the email
    Then in the email subject I should see "Claim your page on the new Mindapples website!"
    When I click the link containing "register" in the email

    Then I should see a "person[email]" text field containing "mindy@example.com"
    When I fill in "Choose a username" with "wibble"
    And I fill in "Password" with "mynewpassword"
    And I fill in "Confirm password" with "mynewpassword"
    And I press "Submit"

    Then I should see "My five a day"
    And I should see "Thanks for registering your Mindapples page"

