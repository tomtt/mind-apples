@committed

Feature: My network
  In order to find out more about people similar to me
  As a person that is part of a network
  I want to browse the mindapples of other people in my network

  Scenario: Networked person goes to her network
    Given a network exists with name: "4Beauty", description: "The 4Beauty form", url: "4beauty", logo_file_name: "beaudiful_logo.jpg"
    And a network exists with name: "Lambeth"
    And I have a personal page
    And my password is "eagleeyed"
    And I belong to the "4Beauty" network
    When I log in

    Then I should not see "Take the test"
    When I follow "My community"
    Then I should see "The 4Beauty form"
    And I should see the "medium" sized "logo" image attachment for the network with name: "4Beauty"
    And I should be on "/in/4beauty/welcome"

  Scenario: Person not in a network does not see a link to a network
    Given I have a personal page
    And my password is "eagleeyed"
    When I log in
    Then I should not see "Take the test"
    And I should not see "My community"
