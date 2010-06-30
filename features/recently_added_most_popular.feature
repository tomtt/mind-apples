@pivotal_3774115

Feature: As a social butterfly I would like to see the most popular and recently added sections of the home page
  In order to keep home page actual
  As a user
  I want see most popular and recently added section on the homepage

  Scenario: As a curious cat I can see the 'Most recent' section
    Given person "andy" exists with login: "andyman", name: "Andy Gibson", email: "andy@overlord.com"
    And person "anonym" exists with login: "miss_bashful", name: "", email: "miss@bashful.com"
    And person "anonym2" exists with login: "autogen_asdasd", page_code: "asdasd", email: "annonym@annonym.com"
    And person "anonym3" exists with login: "autogen_bcdefr", page_code: "bcdefr", email: "annony3m@annonym.com"

    And a mindapple "mindapple1" exists with suggestion: "wrestling with bears", person: person "andy"
    And a mindapple "mindapple2" exists with suggestion: "eating ice cream", person: person "anonym"
    And a mindapple "mindapple3" exists with suggestion: "running naked", person: person "anonym2"
    And a mindapple "mindapple4" exists with suggestion: "", person: person "anonym3"

    Then I am on the homepage
    And I should see homepage "Most recent" section

    And I should see suggestion "wrestling with bears" for "andy@overlord.com" at mindapple section
    And I should see mindapples id for "andy@overlord.com" at mindapple section
    And I should see name "Andy Gibson" for "andy@overlord.com" at mindapple section
    And I should see the link with name "Andy Gibson" for "annonym@annonym.com" at mindapple section
    
    And I should see suggestion "eating ice cream" for "miss@bashful.com" at mindapple section
    And I should see mindapples id for "miss@bashful.com" at mindapple section
    And I should see name "miss_bashful" for "miss@bashful.com" at mindapple section

    And I should see suggestion "running naked" for "annonym@annonym.com" at mindapple section
    And I should see mindapples id for "annonym@annonym.com" at mindapple section
    And I should see name "anonymous" for "annonym@annonym.com" at mindapple section
    And I should not see the link with name "anonymous" for "annonym@annonym.com" at mindapple section

    And I should not see mindapples id for "annony3m@annonym.com" at mindapple section
