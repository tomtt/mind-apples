@wip

Feature: Upload Data
  In order to provide to mindapples experience to GPs
  As an admin
  I want to be able enter paper entries into the website

  Background:
    Given I am logged in as admin with screen_name: "Administrator"

  Scenario: Admin goes to the Upload Data page
    When I go to the admin home page
    And I follow "Upload Data"
    Then I should be on the Upload Data page

  Scenario: Admin adds a person
    When I go to the Upload Data page
