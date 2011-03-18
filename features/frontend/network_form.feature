@pivotal_5507372

Feature: Networks: custom form
  In order to collect the mindapples of my people
  As a network
  I want a custom form with some copy and tagging users as belonging to my network

  Background:
    Given a network "bhm" exists with name: "Bill Hicks' Marketeers"
    And that network's url is "bill-hicks-marketeers"
    And that network's form_header is "Hey Goat Boys, please fill in the form below!"

  Scenario: Person visits his networks form page and fills it in
    Given I have access to the inbox of "marla@example.com"
    When I go to "/in/bill-hicks-marketeers" 
    Then I should see "Hey Goat Boys, please fill in the form below!"
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Telling people not to smoke"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Putting dollar signs on things"
    And I fill in "person[mindapples_attributes][3][suggestion]" with "Sleeping like a baby"
    And I fill in "Brain dump" with "Amazing stuff"
    And I choose "person_health_check_2"
    And I choose "Female"
    And I select "35-44" from "person[age]"
    And I fill in "Passport control" with "UK"
    And I fill in "Your thing" with "Marketeer extraordinaire"
    And I fill in "Be proud" with "Marla Arson"
    And I fill in "E-mail us" with "marla@example.com"
    And I choose "person_public_profile_true"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should see "My five a day"
    And I should see "Thanks for sharing your mindapples"
    And I should see "Sleeping like a baby"

    Then a person "marla" should exist with email: "marla@example.com"
    And the network "bhm" should be that person's network

    And I should receive an email
    When I open the email
    Then in the email subject I should see "Your Mindapples"

  Scenario: Person first forgets to agree to t&c
    When I go to "/in/bill-hicks-marketeers" 
    And I fill in "E-mail us" with "marla@example.com"
    And I press "Submit"
    And I check "person_policy_checked"
    And I press "Submit"

    Then a person "marla" should exist with email: "marla@example.com"
    And the network "bhm" should be that person's network
