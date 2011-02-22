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
    Then I should see "Claim your page on the new Mindapples website!" in the email subject
    When I click the link containing "password_resets" in the email

    And I fill in "Password" with "mynewpassword"
    And I fill in "Password confirmation" with "mynewpassword"
    And I press "Give me that password and log me in"

    Then I should see "Password successfully updated"

  Scenario: Responder is sent an email which she uses to claim her page, twice
    Given a person "mindy" exists with email: "mindy@example.com", respondent_id: 1475
    And I have access to the inbox of "mindy@example.com"
    When the person "mindy" is sent instructions on how to claim her page
    And I open the most recent email
    And I click the link containing "password_resets" in the email

    And I fill in "Password" with "mynewpassword"
    And I fill in "Password confirmation" with "mynewpassword"
    And I press "Give me that password and log me in"

    And I follow "Log out"

    When the person "mindy" is sent instructions on how to claim her page
    And I open the most recent email
    And I click the link containing "password_resets" in the email

    And I fill in "Password" with "mynewpassword"
    And I fill in "Password confirmation" with "mynewpassword"
    And I press "Give me that password and log me in"

    Then I should see "Password successfully updated"
