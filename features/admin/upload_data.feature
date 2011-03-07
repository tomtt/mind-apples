Feature: Upload Data
  In order to provide to mindapples experience to GPs
  As an admin
  I want to be able enter paper entries into the website

  Background:
    Given I am an admin
    And I am logged in

  @wip
  Scenario: Admin goes to the Upload Data page
    When I go to the CMS page
    And I follow "Upload Data"
    And I select a sample csv file to upload
    And I press "Submit"
    Then I should see which users failed to import
