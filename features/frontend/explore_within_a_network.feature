@pivotal_9161315

Feature: Explore network within a network
  In order to search for mindapples within my community
  As the curious cat
  I want search box producing only results from people in my community

  Scenario: Searching for mindapples
    Given a network "4beauty" exists with name: "4Beauty"
    And a network "lambeth" exists with name: "Lambeth"

    And a person "ann" exists with network: network "4beauty"
    And a person "bob" exists with network: network "lambeth"
    And a person "cas" exists

    And a mindapple "4b-mindapple-one" exists with person: person "ann", suggestion: "feeding deer in the park"
    And a mindapple "4b-mindapple-two" exists with person: person "ann", suggestion: "running on the beach"
    And a mindapple "la-mindapple-one" exists with person: person "bob", suggestion: "gathering leaves in the park"
    And a mindapple "la-mindapple-two" exists with person: person "bob", suggestion: "dancing around the campfire"
    And a mindapple "no-mindapple-one" exists with person: person "cas", suggestion: "kissing in the park"
    And a mindapple "no-mindapple-two" exists with person: person "cas", suggestion: "running around trees"

    And I have a personal page
    And my password is "eagleeyed"
    And I belong to the "4Beauty" network
    When I log in
    And I follow "My community"
    And I fill in "Find new things to do" with "park"
    And I press "Find"
    
    Then I should see "feeding deer in the park"
    And I should not see "running on the beach"
    And I should not see "gathering leaves in the park"
    And I should not see "dancing around the campfire"
    And I should not see "kissing in the park"
    And I should not see "climbing trees"

    # Now check that the search box 'remembers' the context of the network
    When I fill in "Find new things to do" with "running"
    And I press "Find"

    Then I should see "running on the beach"
    And I should not see "running around trees"

    # Now check that the search box still 'remembers' the context of the network after an error
    When I fill in "Find new things to do" with "xx"
    And I press "Find"
    And I fill in "Find new things to do" with "running"
    And I press "Find"

    Then I should see "running on the beach"
    And I should not see "running around trees"

  Scenario: Searching for mindapples without any result
    Given a network "4beauty" exists with name: "4Beauty"
    And a network "lambeth" exists with name: "Lambeth"

    And a person "ann" exists with network: network "4beauty"
    And a person "bob" exists with network: network "lambeth"
    And a person "cas" exists

    And a mindapple "4b-mindapple-one" exists with person: person "ann", suggestion: "feeding deer in the park"
    And a mindapple "4b-mindapple-two" exists with person: person "ann", suggestion: "running on the beach"
    And a mindapple "la-mindapple-one" exists with person: person "bob", suggestion: "gathering leaves in the park"
    And a mindapple "la-mindapple-two" exists with person: person "bob", suggestion: "dancing around the campfire"
    And a mindapple "no-mindapple-one" exists with person: person "cas", suggestion: "kissing in the park"
    And a mindapple "no-mindapple-two" exists with person: person "cas", suggestion: "climbing trees"

    And I have a personal page
    And my password is "eagleeyed"
    And I belong to the "4Beauty" network
    When I log in
    And I follow "My community"
    And I fill in "Find new things to do" with "shooting"
    And I press "Find"
    
    Then I should not see "feeding deer in the park"
    And I should not see "running on the beach"
    And I should not see "gathering leaves in the park"
    And I should not see "dancing around the campfire"
    And I should not see "kissing in the park"
    And I should not see "climbing trees"

    And I should see "Sorry, it seems that we can't find what you are looking for."
