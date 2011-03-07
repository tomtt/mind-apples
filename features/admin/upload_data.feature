Feature: Upload Data
  In order to provide to mindapples experience to GPs
  As an admin
  I want to be able enter paper entries into the website

  Background:
    Given I am an admin
    And I am logged in

  @wip
  Scenario: Admin goes to the Upload Data page
    Given a network exists with name: "4Beauty"
    And a network exists with name: "Lambeth"
    When I go to the CMS page
    And I follow "Upload Data"
    And I select "4Beauty" from "network"
    And I fill in "user_type_description" with "Secret Garden Party Attendee 2011"
    And I select a sample csv file to upload
    And I press "Process the CSV file"
    Then I should see which users failed to import
