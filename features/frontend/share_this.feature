@pivotal_3772738

Feature: As a Social Butterfly I would like to invite others to MA by posting to facebook/twitter
  In order to let visitors share content through social network sites
  As a user
  I want a share this link in the ____ page

  Scenario: I can share something through twitter
    Given I have a personal page
    And my login is "visible_ninja"
    And I am logged in
    When I go to "/person/visible_ninja"
    And I should see a link to "http://twitter.com/share"
    
  Scenario: I can share something through twitter
    Given I have a personal page
    And my login is "visible_ninja"
    And I am logged in
    When I go to "/person/visible_ninja"
    And I should see a facebook button

  Scenario: I can see the social media sharing popup after creating my mindapples (only once)
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Playing the piano"
    And I fill in "Your name" with "Andy Gibson"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should be on the "register" page for person "Andy Gibson"
    When I fill in "Choose a username" with "AndyG"
    And I fill in "person[email]" with "andy@mindapples.org"
    And I fill in "Password" with "Secret"
    And I fill in "Confirm password" with "Secret"
    And I press "Submit"
    Then I should see the social media sharing popup
    When I go to "/person/AndyG"
    Then I should not see the social media sharing popup

  Scenario: Anonymous person does not see social media sharing popup
    When I go to the "take the test" page
    And I fill in "person[mindapples_attributes][0][suggestion]" with "Writing Cucumber tests"
    And I check "person_policy_checked"
    And I press "Submit"
    And I follow "skip this step"
    Then I should see "My five a day"
    And I should not see the social media sharing popup
