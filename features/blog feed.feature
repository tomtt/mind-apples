@pivotal_3774315
@pivotal_3774168
@wip

Feature: Feed parsing
  In order to share feeds from the blog
  As the evil overlord
  I want the blog feed to come through the wordpress

Scenario: Feed contain proper values
  Given mind apple feed from the file "feed.xml"
  And mind apple feed is consumed
  When I am on the homepage
  Then I should see "News"
  And I should see "The missing middle of modern meditation"
  And I should see "I have a lot of conversations about meditation.  And over the last few years, as the mainstream interest in meditation has grown and I&#8217;ve met more and more people wanting to learn the practice and the theory of meditation &#8211; and in particular mindfulness-based meditation &#8211;  the supply to satisfy the demand of that interest"
  And I should see "Published 31 May 2010"
  And I should see "Posted by Rohan Gunatillake"
  And I should see "read more" with "http://mindapples.org/?p=933" url
  And I should not see "A brief history of mindfulness Andy Gibson"


