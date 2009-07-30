Feature: Asking for five a day
  In order to gather suggestions
  As the evil overlord
  I want respondents to enter suggestions

  Scenario: Social Butterfly visits homepage
    When I go to the homepage
    Then I should be on the "take the survey" page

  Scenario: Social Butterfly fills in the survey
    When I go to the "take the survey" page
    And I fill in "respondent[mind_apples_attributes][0][suggestion]" with "Playing the piano"
    And I fill in "respondent[mind_apples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "respondent[mind_apples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "respondent[mind_apples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Submit"
    And I fill in "Braindump" with "Amazing stuff"
    And I fill in "Health check" with "3"
    And I choose "Male"
    And I select "35-44" from "respondent[age]"
    And I fill in "Location" with "UK"
    And I fill in "Occupation" with "social guru"
    And I fill in "Name" with "Andy Gibson"
    And I fill in "Email" with "andy@sociability.org.uk"
    And I press "Submit"
    Then I should see "Thank you"
    And I should see "Playing the piano"
    And I should see "Being in nature"
    And I should see "Interesting conversation"
    And I should see "Tidying and filing"
    And I should see "social guru"
    And I should see "3"
    And I should see "35-44"
    And I should see "UK"
    And I should see "Andy Gibson"
    And I should see "Amazing stuff"
    And I should see "andy@sociability.org.uk"
