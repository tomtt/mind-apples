ActionController::Routing::Routes.draw do |map|
  map.resources :blog_feeds

  # Resources
  map.resource :user_session
  map.resources :people, :as => "person", :except => [:index]
  map.connect '/person/:id/favourites', :controller => 'people', :action => 'favourites'

  map.resources :password_resets

  # Named routes
  map.root :controller => "pages", :action => "home"
  map.login '/login', :controller => "user_sessions", :action => "new"
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  # Individual pages
  map.about '/about', :controller => "pages", :action => "about"
  map.team '/about/team', :controller => "pages", :action => "about_team"
  map.how_we_got_here '/about/how-we-got-here', :controller => "pages", :action => "how_we_got_here"
  map.organisation '/about/organisation', :controller => "pages", :action => "organisation"
  map.research '/about/research', :controller => "pages", :action => "research"
  map.contact '/about/contact', :controller => "pages", :action => "contact"
  map.media '/about/media', :controller => "pages", :action => "media"

  map.fives '/fives', :controller => "pages", :action => "fives"
  map.pledge '/pledge', :controller => "pages", :action => "pledge"

  map.grow '/grow', :controller => "pages", :action => "grow"
  map.donate '/grow/donate', :controller => "pages", :action => "donate"
  map.volunteer '/grow/volunteer', :controller => "pages", :action => "volunteer"
  map.grow_your_own '/grow/grow_your_own', :controller => "pages", :action => "grow_your_own"

  map.links '/links', :controller => "pages", :action => "links"
  map.media '/media', :controller => "pages", :action => "media"
  map.terms '/terms', :controller => "pages", :action => "terms"

  map.services '/services', :controller => "pages", :action => "services"
  map.individuals '/services/individuals', :controller => "pages", :action => "individuals"
  map.workplaces '/services/workplaces', :controller => "pages", :action => "workplaces"
  map.schools '/services/schools', :controller => "pages", :action => "schools"
  map.niversities '/services/universities', :controller => "pages", :action => "universities"
  map.communities '/services/communities', :controller => "pages", :action => "communities"
  map.healthcare '/services/healthcare', :controller => "pages", :action => "healthcare"

  map.privacy '/privacy', :controller => "pages", :action => "privacy"

  map.like '/person/likes/:id', :controller => 'people', :action => 'likes'
  map.unlike '/person/unlikes/:id', :controller => 'people', :action => 'unlikes'

  # Generic routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '/this-is-a-page-that-blows-up-to-test-the-500-error', :controller => 'errors', :action => 'error500'
end
