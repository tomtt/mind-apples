@pivotal_3772759

Feature: Mindapples Home Page
  In order to give the user a starting point
  As a user
  I want to see the Mindapples home page

  Scenario: As a curious cat I can see the What? section
    When I go to the homepage
    Then I should see the "green_question_mark.png" image with alt "question mark"
    And I should see "What are your mindapples?"
    And I should see the "green_comment_bubble.png" image with alt "comment bubble"
    And I should see "Tell us what you do"
    And I should see the "two_green_arrows.png" image with alt "two arrows"
    And I should see "Find new things to do" 
    And I should see the "green_heart.png" image with alt "heart"
    And I should see "Love your mind"

  Scenario: As a curious cat I can see the 5 a day section
    When I go to the homepage
    Then I should see "What are your mindapples?"
    And I should see a "person[mindapples_attributes][0][suggestion]" text field
    And I should see a "person[mindapples_attributes][1][suggestion]" text field
    And I should see a "person[mindapples_attributes][2][suggestion]" text field
    And I should see a "person[mindapples_attributes][4][suggestion]" text field
    And I should see a "go.png" image button

  Scenario: As a logged in user I can't see the What? section
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"

    And I go to the homepage
    Then I should not see the "green_question_mark.png" image with alt "question mark"
    And I should not see "What's the 5 a day for your mind?"
    And I should not see the "green_comment_bubble.png" image with alt "comment bubble"
    And I should not see "Share what works for you"
    And I should not see the "two_green_arrows.png" image with alt "two arrows"
    And I should not see "Discover new things to do"
    And I should not see the "green_heart.png" image with alt "heart"
    And I should not see "Love your mind"

  Scenario: As a logged in user I can't see the 5 a day section
    Given I have a personal page
    And my login is "gandy"
    And my password is "sosocial"
    And my braindump is "Mindapples rocks"
    And my email is "gandy@example.com"
    When I go to the login page
    And I fill in "Login" with "gandy"
    And I fill in "Password" with "sosocial"
    And I press "Log in"
    And I go to the homepage

    Then I should not see "What are your mindapples?"
    And I should not see a "person[mindapples_attributes][0][suggestion]" text field
    And I should not see a "person[mindapples_attributes][1][suggestion]" text field
    And I should not see a "person[mindapples_attributes][2][suggestion]" text field
    And I should not see a "person[mindapples_attributes][4][suggestion]" text field

  @top_apples
  Scenario: As a not logged in user i can see the Top Apples section
    Given I am on the homepage
    And a mindapple "mindapple1" exists with suggestion: "mindapple1"
    And a mindapple "mindapple2" exists with suggestion: "mindapple2"
    And a mindapple "mindapple3" exists with suggestion: "mindapple3"
    And a mindapple "mindapple4" exists with suggestion: "mindapple4"
    And a mindapple "mindapple5" exists with suggestion: "mindapple5"
    And a mindapple "mindapple6" exists with suggestion: "mindapple6"

    And 5 people liked mindapple "mindapple1"
    And 4 people liked mindapple "mindapple2"
    And 3 people liked mindapple "mindapple3"
    And 2 people liked mindapple "mindapple4"
    And 1 people liked mindapple "mindapple5"
    And 0 people liked mindapple "mindapple6"
