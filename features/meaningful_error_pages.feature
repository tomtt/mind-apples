@development

Feature: Meaningful error pages
  In order to inform visitors
  As the evil overlord
  I want a meaningful 404/422/500 page

  Scenario: User hits a url of a non existing person
    When I go to "/person/visible_ninja"
    Then I should see "No such person"
    And the response status should be 404
