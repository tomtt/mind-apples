@pivotal_4192987
@wp
Feature: Explore page
  In order to search for mindapples
  As the curios cat
  I want search box and mindapples cloud
  
  Scenario: Searching for mindapples
    Given I am on the "Explore" page
    And a mindapple "mindapple1" exists with suggestion: "mindapple1"
    And a mindapple "mindapple2" exists with suggestion: "mindapple2"
    And a mindapple "mindapple3" exists with suggestion: "mindapple3"
    And a mindapple "mindapple4" exists with suggestion: "mindapple4"
    And a mindapple "mindapple5" exists with suggestion: "mindapple5"
    And a mindapple "mindapple6" exists with suggestion: "mindapple6"
    # 
    # When fill 
    # Then outcome
