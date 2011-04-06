ActionController::Routing::Routes.draw do |map|
  map.resources :mindapples, :as => "fives"

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
  map.evidence '/about/evidence', :controller => "pages", :action => "evidence"
  map.contact '/about/contact', :controller => "pages", :action => "contact"
  map.media '/about/media', :controller => "pages", :action => "media"
  map.debug '/debug', :controller => "pages", :action => "debug"

  # map.fives '/fives', :controller => "pages", :action => "five"
  map.pledge '/pledge', :controller => "pages", :action => "pledge"

  map.grow '/grow', :controller => "pages", :action => "grow"
  map.join_us '/grow/join_us', :controller => "pages", :action => "join_us"
  map.partnerships '/grow/partnerships', :controller => "pages", :action => "partnerships"
  map.volunteer '/grow/volunteer', :controller => "pages", :action => "volunteer"
  map.grow_your_own '/grow/grow_your_own', :controller => "pages", :action => "grow_your_own"

  map.links '/links', :controller => "pages", :action => "links"
  map.media '/media', :controller => "pages", :action => "media"
  map.terms '/terms', :controller => "pages", :action => "terms"

  map.services '/services', :controller => "pages", :action => "services"
  map.individuals '/services/individuals', :controller => "pages", :action => "individuals"
  map.workplaces '/services/workplaces', :controller => "pages", :action => "workplaces"
  map.schools '/services/schools', :controller => "pages", :action => "schools"
  map.universities '/services/universities', :controller => "pages", :action => "universities"
  map.communities '/services/communities', :controller => "pages", :action => "communities"
  map.healthcare '/services/healthcare', :controller => "pages", :action => "healthcare"
  map.engagement '/services/engagement', :controller => "pages", :action => "engagement"
  map.testimonials '/services/testimonials', :controller => "pages", :action => "testimonials"
  map.research '/services/research', :controller => "pages", :action => "research"
  map.training '/services/training', :controller => "pages", :action => "training"
  map.wellbeing_programmes '/services/wellbeing_programmes', :controller => "pages", :action => "wellbeing_programmes"

  map.privacy '/privacy', :controller => "pages", :action => "privacy"
  map.thebigtreat '/thebigtreat', :controller => "pages", :action => "bigtreat"

  map.like '/person/likes/:id', :controller => 'people', :action => 'likes'
  map.unlike '/person/unlikes/:id', :controller => 'people', :action => 'unlikes'

  # networks
  # currently networks are done hackily due to lack of time. the desired structure is to have
  # the page for a person signing up at /in/:network/people/new and the network page at /in/:network
  # which might redirect to the login page if no user is logged in
  map.network "/in/:network", :controller => "people", :action => "new"
  map.network "/in/:network/welcome", :controller => "networks", :action => "show"
  map.network_admin "/in/:network/admin", :controller => "networks", :action => "admin"

  # widgets
  # map.widget "/widgets/form"

  map.namespace :admin do |admin|
    admin.root  :controller => 'admin'
    admin.resources :people_imports
    admin.resources :people
  end

  # Generic routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '/this-is-a-page-that-blows-up-to-test-the-500-error', :controller => 'errors', :action => 'error500'
end
