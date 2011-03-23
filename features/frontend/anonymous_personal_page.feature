@pivotal_1292369
@pivotal_4029941

Feature: Anonymous personal page

  Scenario: Person sees his page
    When I go to the "take the test" page
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should see "My five a day"

  Scenario: Login is not validate if is autogenerated
    Given I am on the "take the test" page
    And I press "Submit"
    And I check "person_policy_checked"
    And I press "Submit"
    Then I should not see "Login can not start with 'autogen_'"
    And I should see "My five a day"

  Scenario: Somebody else sees his page
    Given I have a personal page
    When I go to my mindapples page
    Then I should see "My five a day"
    And I should see "What do you do to look after your mind?"