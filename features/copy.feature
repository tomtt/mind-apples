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
    And I should see "What else do you need to stay mentally well?"

    And I should not see "Leave your e-mail and we'll send you occasional messages. "
    And I should see "Leave your e-mail and we'll send you your mindapples. "

    And I should not see "Once more with the password please, in case of typos..."
    And I should see "Again with the password please, in case of typos."

    And I should not see "Yes, I'm happy to make my profile public on Mindapples.org"
    And I should see "Yes, I'm happy to make my profile public"

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
    And I should see "Take the test"
    And I follow "Take the test"
    Then I should see "Take the Mindapples test"
    And I should be on "/person/new"
    And I should not see "Choose a username for your Mindapples account.(careful, you can only choose once)"
    And I should see "Choose a username to claim your Mindapples account."

  Scenario: Explore menu link
    When I go to the homepage
    Then I should see "Explore"
    When I follow "Explore"
    Then I should see "Search"
    And I should be on "/fives"
  
  Scenario: Services menu link
    When I go to the homepage
    Then I should see "Services"
    When I follow "Services"
    Then I should see "Mindapples services"
    And I should be on "/services"
    
  Scenario: Help us grow menu link
    When I go to the homepage
    Then I should see "Help us grow"
    When I follow "Help us grow"
    Then I should see "Help us grow"
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
  # Scenario: Company information
  #   When I go to the homepage
  #   Then I should see "Mindapples is a non-profit organisation registered in England and Wales number 07264252."

  Scenario: Terms menu link
    Given I am on the homepage
    And I should see "Terms & conditions"
    And I follow "Terms & conditions"
    Then I should see "Terms & conditions"
    And I should be on "/terms"

  Scenario: Privacy menu link
    When I go to the homepage
    Then I should see "Privacy policy"
    When I follow "Privacy policy"
    Then I should see "Privacy policy"
    And I should be on "/privacy"
    # New path for /privacy
  
  # Scenario: Unboxed logo
  #   When I go to the homepage
  #   Then I should see the Unboxed logo
  #   When I click on the Unboxed logo
  #   Then I should be at URL "http://www.unboxedconsulting.com"
  # 
  # Scenario: UnLtd logo
  #   When I go to the homepage
  #   Then I should see the UnLtd logo
  #   When I click on the UnLtd logo
  #   Then I should be at URL "http://www.unltd.org.uk"
  # 
  # Scenario: Nominet Trust logo
  #   When I go to the homepage
  #   Then I should see the Nominet Trust logo
  #   When I click on the Nominet Trust logo
  #   Then I should be at URL "http://www.nominettrust.org.uk"
  # 
  # Scenario: Volunteers menu link
  #   When I go to the homepage
  #   Then I should see "Mindapples volunteers"
  #   When I follow "Mindapples volunteers"
  #   Then I should see "Who we are"
  #   And I should be on "/about/team"
# 
# #About us section menu
# # NB. We haven't got a plan for section menus at the moment, so I've put them in the pages themselves for now...
# 
#   Scenario: Who we are menu link
#     When I go to the "about" page
#     Then I should see "Who we are"
#     When I follow "Who we are"
#     Then I should see "Andy Gibson"
#     And I should see "Tessy Britton"
#     And I should be on "/about/team"
# 
#   Scenario: The organisation menu link
#     When I go to the "about" page
#     Then I should see "Organisation"
#     When I follow "Organisation"
#     Then I should see "Our organisation"
#     And I should be on "/about/organisation"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Research menu link
#     When I go to the "about" page
#     Then I should see "Research"
#     When I follow "Research"
#     Then I should see "Mindapples research and methodology"
#     And I should be on "/about/research"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Contact menu link
#     When I go to the "about" page
#     Then I should see "Contact"
#     When I follow "Contact"
#     Then I should see "Contact us"
#     And I should be on "/about/contact"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Media menu link
#     When I go to the "about" page
#     Then I should see "Media"
#     When I follow "Media"
#     Then I should see "Mindapples in the media"
#     And I should be on "/about/media"
#   #New path for /media
# 
# #Services section menu
# 
#   Scenario: Individuals services link
#     When I go to the "services" page
#     Then I should see "Individuals"
#     When I follow "Individuals"
#     Then I should see "Mindapples for individuals"
#     And I should be on "/services/individuals"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Workplaces services link
#     When I go to the "services" page
#     Then I should see "Workplaces"
#     When I follow "Workplaces"
#     Then I should see "Mindapples at work"
#     And I should be on "/services/workplaces"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Schools services link
#     When I go to the "services" page
#     Then I should see "Schools"
#     When I follow "Schools"
#     Then I should see "Mindapples in schools"
#     And I should be on "/services/schools"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Universities services link
#     When I go to the "services" page
#     Then I should see "Universities"
#     When I follow "Universities"
#     Then I should see "Mindapples in universities"
#     And I should be on "/services/universities"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Communities services link
#     When I go to the "services" page
#     Then I should see "Communities"
#     When I follow "Communities"
#     Then I should see "Mindapples in communities"
#     And I should be on "/services/communities"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Healthcare services link
#     When I go to the "services" page
#     Then I should see "Healthcare"
#     When I follow "Healthcare"
#     Then I should see "Mindapples in healthcare"
#     And I should be on "/services/healthcare"
#   #New page for this has been added in the pages directory
# 
# #Grow section menu
# #NB. Changed the path for this section to /grow
# 
#   Scenario: Donate link
#     When I go to the "grow" page
#     Then I should see "Donate"
#     When I follow "Donate"
#     Then I should see "please donate"
#     And I should be on "/grow/donate"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Volunteer link
#     When I go to the "grow" page
#     Then I should see "Volunteer"
#     When I follow "Volunteer"
#     Then I should see "Volunteer with us"
#     And I should be on "/grow/volunteer"
#   #New page for this has been added in the pages directory
# 
#   Scenario: Grow your own link
#     When I go to the "grow" page
#     Then I should see "Grow your own"
#     When I follow "Grown your own"
#     Then I should see "Grow your own mindapples"
#     And I should be on "/grow/grow_your_own"
#   #New page for this has been added in the pages directory
# 
# 
