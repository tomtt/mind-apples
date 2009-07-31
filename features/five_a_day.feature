@committed
Feature: Asking for five a day
  In order to gather suggestions
  As the evil overlord
  I want respondents to enter suggestions

  Scenario: Social Butterfly visits homepage
    When I go to the homepage
    Then I should be on the "take the survey" page

  Scenario: Social Butterfly fills in the survey
    When I go to the "take the survey" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I fill in "person[mindapples_attributes][1][suggestion]" with "Being in nature"
    And I fill in "person[mindapples_attributes][2][suggestion]" with "Interesting conversation"
    And I fill in "person[mindapples_attributes][4][suggestion]" with "Tidying and filing"
    And I press "Submit"
    And I fill in "Brain dump. Anything else you'd like to tell us? What else do you need to stay mentally healthy?" with "Amazing stuff"
    And I fill in "Health check. How would you rate your mental health? (1 is bad, 5 good)" with "2"
    And I choose "Male"
    And I select "35-44" from "person[age]"
    And I fill in "Border control. Where are you from?" with "UK"
    And I fill in "What's your thing? What do you do for a living or to fill your time?" with "social guru"
    And I fill in "Be proud. What's your name? (very optional)" with "Andy Gibson"
    And I fill in "Don't go! Leave your e-mail to keep in touch with Mindapples. (never made public)" with "andy@example.com"
    And I press "Submit"
    Then I should see "Thank you"
    And I should see "Playing the piano"
    And I should see "Being in nature"
    And I should see "Interesting conversation"
    And I should see "Tidying and filing"
    And I should see "Amazing stuff"
    And I should see "2"
    And I should see "Male"
    And I should see "35-44"
    And I should see "UK"
    And I should see "social guru"
    And I should see "Andy Gibson"
    And I should see "andy@example.com"
