Feature: Personal page
  Personal page

  Background:
    Given a network "4beauty" exists with url: "4beauty", description: "welcome to 4Beauty"
    And a network "lambeth" exists with name: "Lambeth"

    And I have a personal page
    And my login is "gandy"
    And my password is "sosocial"

  Scenario: Logging in from a network page, failing at first attempt
    When I go to the network page for "4beauty"
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "oopsy"
    And I press "Log in"
    Then I should see "we don't recognise that username and password combination"

    When I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"

    Then I should see "welcome to 4Beauty"
