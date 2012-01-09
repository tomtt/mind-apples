@pivotal_3774068
@pivotal_4096079

Feature: Favourite Mindapples
  In order to customize the mindapple experience
  As a logged in user
  I want to see my favourite mindapples

  Scenario: seeing my favourites mindapples
    Given person "test_user" exists with email: "test@example.com"
    And person: "test_user" has 12 liked mindapples
    And I have a personal page
    And my login is "test_login"
    And my email is "test@example.com"
    And my password is "secret"
    And my braindump is "I love Mindapples"
    When I log in
    And I go to my favourite mindapples page
    Then I should see a link to "previous"
    And I should see a link to "next"
    And I should see a link to "like"
    And I should be on "/person/test_login/favourites"

  Scenario: seeing my favourites mindapples on proper url address
    Given person "test_user" exists with email: "test@example.com", page_code: "abcdrf"
    And person: "test_user" has 12 liked mindapples
    And I have a personal page
    And my login is "autogen_abcdrf"
    And my email is "test@example.com"
    And my password is "secret"
    And my braindump is "I love Mindapples"
    When I log in
    And I go to "/person/_abcdrf/favourites"
    Then I should see a link to "previous"
    And I should see a link to "next"
    And I should see a link to "like"
