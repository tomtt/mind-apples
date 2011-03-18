@pivotal_3999918

#Homepage copy check
Feature: Proper layouts structure
  In order to explain why Mindapples
  As the evil overlord
  I want proper page hierarchy

  Scenario: Homepage 5-a-day form
    When I go to the homepage
    Then I should see "What are your mindapples?"
    And I should not see "Important bit."

#Registration form copy changes

  Scenario: Homepage 5-a-day form
    Given I have a personal page
    And my login is "anna"
    And my password is "apples"
    And my braindump is "I love Mindapples"
    When I log in
    And I go to "anna" edit page
    And I should not see "What else do you need to stay mentally healthy?"
    And I should see "What else do you need to look after your mind?"

    And I should not see "Leave your e-mail and we'll send you occasional messages. "
    And I should see "E-mail us! Leave your e-mail and we'll post you your mindapples. (never made public)"

    And I should not see "Once more with the password please, in case of typos..."
    And I should see "And again with the password please"

    And I should not see "Yes, I'm happy to make my profile public on Mindapples.org"
    And I should see "Show yourself. Can other people see your profile?"

    And I should not see "Where do you live?"
    And I should see "Which country are you from?"

# #Top menu links
# 
  Scenario: About us menu link
    When I go to the homepage
    Then I should see "About us"
    And I should not see "Get Involved"
    When I follow "About us"
    Then I should see "About Mindapples"
    And I should be on "/about"

  Scenario: Take the test menu link
    When I go to the homepage
    And I follow "Take the test"
    Then I should see "Take the Mindapples test"
    And I should be on "/person/new"
    And I should not see "Choose a username for your Mindapples account.(careful, you can only choose once)"
    And I should see "Choose a username."

  Scenario: Explore menu link
    When I go to the homepage
    And I follow "Explore"
    Then I should see "Search"
    And I should be on "/fives"

  Scenario: Hire Us menu link
    When I go to the homepage
    And I follow "Hire Us"
    Then I should see "Mindapples services"
    And I should be on "/services"
    
  Scenario: Join us menu link
    When I go to the homepage
    Then I should see "Join us"
    When I follow "Join us"
    Then I should see "Join us"
    And I should be on "/grow"
  #Moved /help-us-grow page to /grow
  
  Scenario: Blog menu link
    When I go to the homepage
    And I should see "Blog"
    Then I follow "Blog"
    And I should see "Blog" link with "http://mindapples.wordpress.com" url
  #Hope that's the right way to write the test for an external link
  
# #Footer
# # NB. Some of the footer links are duplicated above, so not sure how to test them...
# 
  Scenario: Company information
    When I go to the homepage
    Then I should see "Mindapples is an independent non-profit organisation"

  Scenario: Terms menu link
    Given I am on the homepage
    And I should see "Terms & conditions"
    And I follow "Terms & conditions"
    Then I should see "Terms & conditions"
    And I should be on "/terms"

  Scenario: copyright
    Given I am on the homepage
    And I should see "This site was built by Unboxed Consulting and the Mindapples volunteers, funded and supported by UnLtd and the Nominet Trust"

  Scenario: Privacy menu link
    When I go to the homepage
    Then I should see "Privacy policy"
    When I follow "Privacy policy"
    Then I should see "Privacy policy"
    And I should be on "/privacy"
    # New path for /privacy

  Scenario: Unboxed logo
    When I go to the homepage
    And I should see "Unboxed Consulting" link with "http://www.unboxedconsulting.com" url
    And I should see "UnLtd*" link with "http://www.unltd.org.uk" url
    And I should see "Nominet Trust" link with "http://www.nominettrust.org.uk" url
    Then I follow "Mindapples volunteers"
    And I should be on "/about/team"
# 
# #About us section menu
# # NB. We haven't got a plan for section menus at the moment, so I've put them in the pages themselves for now...
# 
  Scenario: Who we are menu link
    When I go to the "about" page
    Then I should see "Who we are"
    And I should see "The idea"
    When I follow "Who we are"
    Then I should see "Andy Gibson"
    And I should see "Tessy Britton"
    And I should be on "/about/team"

  Scenario: The organisation menu link
    When I go to the "about" page
    Then I should see "Organisation"
    When I follow "Organisation"
    Then I should see "Our organisation"
    And I should be on "/about/organisation"

  Scenario: Evidence menu link
    When I go to the "about" page
    Then I should see "Evidence"
    When I follow "Evidence"
    Then I should see "Mindapples evidence and approach"
    And I should be on "/about/evidence"

  Scenario: Contact menu link
    When I go to the "about" page
    Then I should see "Contact"
    When I follow "Contact"
    Then I should see "Contact us"
    And I should be on "/about/contact"

  Scenario: Media menu link
    When I go to the "about" page
    Then I should see "Media"
    When I follow "Media"
    Then I should see "Mindapples in the media"
    And I should be on "/about/media"
