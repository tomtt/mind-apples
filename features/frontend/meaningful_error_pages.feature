@pivotal_1292210

Feature: Meaningful error pages
  In order to inform visitors
  As the evil overlord
  I want a meaningful 404/422/500 page

  Scenario: visiting a non-existant page
    When I go to "/person/visible_ninja"
    Then the response status should be 404
    And I should see "Sorry, the page you were looking for does not exist"

  # @allow-rescue
  # Scenario: visiting a page that blows up
  #   When I try to go to the url "this-is-a-page-that-blows-up-to-test-the-500-error"
  #   Then the response status should be 500
  #   And I should see "Sorry, something went wrong"
    