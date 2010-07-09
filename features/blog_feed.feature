@pivotal_3774315
@pivotal_3774168

Feature: Feed parsing
  In order to share feeds from the blog
  As the evil overlord
  I want the blog feed to come through the wordpress

Scenario: Feed contain proper values
  Given mind apple feed from the url "http://mindapples.org/feed/" is consumed
  When I am on the homepage
  Then I should see "News"
  And I should see 3 news items
  And I should see "The missing middle of modern meditation"
  And I should see "I have a lot of conversations about meditation.  And over the last few years, as the mainstream interest in meditation has grown and I’ve met more and more people wanting to learn the practice and the ..."
  And I should see "Posted by 21awake on 31 May 2010"
  And I should see "(Read more)" with "http://mindapples.org/2010/05/31/the-missing-middle-of-modern-meditation/" url at news section

  And I should see "4 days left to support us!"
  And I should see "Hello Mindapplers, We have lots of interesting projects coming up this summer to help raise the awareness of Mindapples and the 5-a-day campaign. Here’s a few juicy highlights… First things first, we’v..."
  And I should see "Posted by Andy Gibson on 12 May 2010"
  And I should see "(Read more)" with "http://mindapples.org/2010/05/12/4-days-left-to-support-us/" url at news section

  And I should see "Rethinking mental illness"
  And I should see "Rethink has created a petition calling for the new UK Parliament to act to improve things for people affected by mental illness. I just signed it, and rather than e-mailing everyone, I thought I’d post..."
  And I should see "Posted by Andy Gibson on 20 Apr 2010"
  And I should see "(Read more)" with "http://mindapples.org/2010/04/20/rethinking-mental-illness/" url at news section

  And I should not see "A brief history of mindfulness Andy Gibson"
