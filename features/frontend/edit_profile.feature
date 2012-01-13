
Feature: Editing my profile
  In order to be able to update my details
  As a user
  I want to be able to edit my profile

  # There should be lots more here, but at the moment, it's scattered around the various other features.

  Scenario: Person tries to edit their page with an invalid login
    Given I have a personal page
    And I am logged in
    When I go to my edit page
    And I fill in "Username" with "test.user"
    And I press "Submit"
    Then I should see "Sorry, usernames can only contain letters, numbers, dash and underscore. Please choose again."
    When I fill in "Username" with "test_user"
    And I press "Submit"
    Then I should see "Thank you for updating your Mindapples page."
    And I should be on "/person/test_user"
