Feature: Filling in the survey
  In order to share my five-a-day
  As a user
  I want to be able to fill them in on a form along with my details

  Scenario: Filling in just my five-a-day without leaving details
    Given I am on the survey page
    When I fill in "apple_1" with "Playing the piano"
    And I fill in "apple_2" with "Being in nature"
    And I fill in "apple_3" with "Interesting conversation"
    And I fill in "apple_4" with "Reading the football papers"
    And I fill in "apple_5" with "Tidying and filing"
    And I press "Submit"

  Scenario: Filling in just my five-a-day leaving all details
    Given I am on the survey page
    When I fill in "apple_1" with "Playing the piano"
    And I fill in "apple_2" with "Being in nature"
    And I fill in "apple_3" with "Interesting conversation"
    And I fill in "apple_4" with "Reading the football papers"
    And I fill in "apple_5" with "Tidying and filing"
    And I fill in "health_check" with "3"
    And I fill in "suggested_people" with "David Beckham  Melvyn Bragg  Stephen Fry  June Sarpong  Stephen Fry"
    And I fill in "age_range" with "35-44"
    And I fill in "country" with "UK"
    And I fill in "name" with "Andy Gibson"
    And I fill in "email" with "andy@sociability.org.uk"
    And I press "Submit"