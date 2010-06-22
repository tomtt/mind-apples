@pivotal_3774150

Feature: Profile photo
  In order to have a profile picture
  As a user
  I want be able to upload picture

  Background:
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"

  Scenario: As a social butterfly I can add a photo
    Given I am on my edit page
    And I fill all mandatory fields
    And I should see "Smile please. Choose a profile picture."
    And I should see a profile picture "missing.png"
    And I should see "person[avatar]" field
    When I upload the picture "smile.jpg"
    And I press "Submit"
    Then I should see "Thank you for updating your Mindapples page."
    And I should see a profile picture "smile.jpg"

  Scenario: As a social butterfly I can delete a photo
    Given profile for "gandy" with picture "smile.jpg"
    When I am on my edit page
    And I fill all mandatory fields
    And I should see "Smile please. Choose a profile picture."
    And I should see a profile picture "smile.jpg"
    And I should see "person[avatar]" field
    And I should see "I don't want use this picture anymore."
    Then I check "delete_avatar"
    And I press "Submit"
    And I should see "Thank you for updating your Mindapples page."
    And I should not see a profile picture "smile.jpg"
    And I should see a profile picture "missing.png"

  Scenario: As a social butterfly I can replace a photo
    Given profile for "gandy" with picture "smile.jpg"
    When I am on my edit page
    And I fill all mandatory fields
    And I should see "Smile please. Choose a profile picture."
    And I should see a profile picture "smile.jpg"
    And I should see "person[avatar]" field
    And I should see "I don't want use this picture anymore."
    And I upload the picture "smile2.jpg"
    And I press "Submit"
    Then I should see "Thank you for updating your Mindapples page."
    And I should see a profile picture "smile2.jpg"
    And I should not see a profile picture "smile.jpg"
