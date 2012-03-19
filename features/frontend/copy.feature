@pivotal_3999918

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
    And I should see "Email address. Leave your e-mail and we'll post you your mindapples. (never made public)"

    And I should not see "Once more with the password please, in case of typos..."
    And I should see "Confirm password"

    And I should not see "Yes, I'm happy to make my profile public on Mindapples.org"
    And I should see "Are you happy for other people to see your profile?"

    And I should not see "Where do you live?"
    And I should see "Passport."
#
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
    And I should see "Blog" link with "http://blog.mindapples.org" url
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
    And I should see "This site was built by"

  Scenario: Privacy menu link
    When I go to the homepage
    Then I should see "Privacy"
    When I follow "Privacy"
    Then I should see "Privacy"
    And I should be on "/privacy"
    # New path for /privacy

  Scenario: Unboxed logo
    When I go to the homepage
    And I should see "Nominet Trust" link with "http://www.nominettrust.org.uk" url
    Then I follow "Mindapples volunteers"
    And I should be on "/about/team"
# 
# #About us section menu
# 
  Scenario: Who we are menu link
    When I go to the "about" page
    Then I should see "Who we are"
    And I should see "The idea"
    When I follow "Who we are"
    Then I should see "Andy Gibson"
    And I should see "Esther King"
    And I should be on "/about/team"

  Scenario: The organisation menu link
    When I go to the "about" page
    Then I should see "Organisation" in the sub nav
    When I follow "Organisation"
    Then I should see "Our organisation" in the h1
    And I should be on "/about/organisation"

  Scenario: Evidence menu link
    When I go to the "about" page
    Then I should see "Evidence" in the sub nav
    When I follow "Evidence"
    Then I should see "The evidence for Mindapples" in the h1
    And I should be on "/about/evidence"

  Scenario: Contact menu link
    When I go to the "about" page
    Then I should see "Contact" in the sub nav
    When I follow "Contact"
    Then I should see "Contact us" in the h1
    And I should be on "/about/contact"

  Scenario: Media menu link
    When I go to the "about" page
    Then I should see "Media" in the sub nav
    When I follow "Media"
    Then I should see "Mindapples in the media" in the h1
    And I should be on "/about/media"
#
#Hire us section menu
#
 Scenario: Engagement hire us link
   When I go to the "Hire us" page
   Then I should see "Engagement" in the sub nav
   When I follow "Engagement"
   Then I should see "Engagement" in the h1
   And I should be on "/services/engagement"

 Scenario: Research hire us link
   When I go to the "Hire us" page
   Then I should see "Insights" in the sub nav
   When I follow "Insights"
   Then I should see "Insights" in the h1
   And I should be on "/services/research"

 Scenario: Training hire us link
   When I go to the "Hire us" page
   Then I should see "Training" in the sub nav
   When I follow "Training"
   Then I should see "Training" in the h1
   And I should be on "/services/training"

 Scenario: Wellness programmes hire us link
   When I go to the "Hire us" page
   Then I should see "Wellness programmes" in the sub nav
   When I follow "Wellness programmes"
   Then I should see "Wellness programmes" in the h1
   And I should be on "/services/programmes"

 Scenario: Testimonials hire us link
   When I go to the "Hire us" page
   Then I should see "Testimonials" in the sub nav
   When I follow "Testimonials"
   Then I should see "What people say" in the h1
   And I should be on "/services/testimonials"
#
#Join us section menu
#
 Scenario: Events link
   When I go to the "Join us" page
   Then I should see "Events" in the sub nav
   When I follow "Events"
   Then I should see "Events" in the h1
   And I should be on "/grow/events"
  
 Scenario: Grow your own link
   When I go to the "Join us" page
   Then I should see "Grow your own" in the sub nav
   When I follow "Grow your own"
   Then I should see "Grow your own mindapples" in the h1
   And I should be on "/grow/grow_your_own"

  Scenario: Volunteer link
   When I go to the "Join us" page
   Then I should see "Volunteer" in the sub nav
   When I follow "Volunteer"
   Then I should see "Volunteer with us" in the h1
   And I should be on "/grow/volunteer"

