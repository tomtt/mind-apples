Feature: Import people
  In order to provide to mindapples experience to GPs
  As an admin
  I want to be able enter paper entries into the website

  Background:
    Given I am an admin
    And I am logged in

  Scenario: Admin goes to the Import People page
    Given a network exists with name: "4Beauty"
    And a network exists with name: "Lambeth"
    When I go to the CMS page
    And I follow "Import People"
    And I select "4Beauty" from "Network that users in CSV belong to"
    And I fill in "Enter a description of who the users are" with "Secret Garden Party Attendee 2011"
    And I select a sample csv file to upload
    And I press "Process the CSV file"
    Then I should see which users failed to import
