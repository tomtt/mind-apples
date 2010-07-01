# This file was just created to purposefully break the build. It can be deleted to fix this.
Feature: Test CI
  In order to keep the build integrated
  I want developers to squeek if the build breaks

  Scenario: Intentionally breaking the build
    When I go to a "nonexistent" page
    Then I should see "this scenario has broken the build and has now served its purpose"
