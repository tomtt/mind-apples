@wip

Feature: Import people
  In order to provide to mindapples experience to GPs
  As an admin
  I want to be able enter paper entries into the website

  Background:
    Given I am an admin
    And I am logged in

  # This feature is not completed due to there not being enough time to work out how to stub out 
  # interactions with S3
  Scenario: Admin goes to the Import People page
    Given a network exists with name: "4Beauty"
    And a network exists with name: "Lambeth"
    And S3 is stubbed to contain one CSV file with the content in "spec/test_data/people_import_sample.csv"
    And a person exists with email: "existing_user@example.com"
    When I go to the CMS page
    And I follow "Import People"
    And I press "Import"
    And I select "4Beauty" from "Network that users in CSV belong to"
    And I fill in "Enter a description of who the users are" with "Secret Garden Party Attendee 2011"
    And I press "Process the CSV file"
    Then I should see which users failed to import
