ActionController::Routing::Routes.draw do |map|
  map.resources :mindapples, :as => "fives"

  map.resources :blog_feeds
  # Omniauth routing
  map.callback "/auth/:provider/callback", :controller => "authentications", :action => "create"
  map.failure "/auth/failure", :controller => "authentications", :action => "failure"


  # Resources
  map.resource :user_session
  map.resources :people, :as => "person", :except => [:index]
  map.connect '/person/:id/favourites', :controller => 'people', :action => 'favourites'
  map.register_person '/person/:id/register', :controller => 'people', :action => 'register'
  map.resources :password_resets, :only => [:index, :create, :edit, :update]

  # Named routes
  map.root :controller => "pages", :action => "home"
  map.login '/login', :controller => "user_sessions", :action => "new"
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  # About pages
  map.about '/about', :controller => "pages", :action => "about"
  map.team '/about/team', :controller => "pages", :action => "team"
  map.how_we_got_here '/about/how-we-got-here', :controller => "pages", :action => "how_we_got_here"
  map.organisation '/about/organisation', :controller => "pages", :action => "organisation"
  map.evidence '/about/evidence', :controller => "pages", :action => "evidence"
  map.contact '/about/contact', :controller => "pages", :action => "contact"
  map.media '/about/media', :controller => "pages", :action => "media"
  map.jobs '/about/jobs', :controller => "pages", :action => "jobs"

  # Sales pages
  map.services '/services', :controller => "pages", :action => "services"
  map.engagement '/services/engagement', :controller => "pages", :action => "engagement"
  map.insights '/services/insights', :controller => "pages", :action => "insights"
  map.training '/services/training', :controller => "pages", :action => "training"
  map.programmes '/services/programmes', :controller => "pages", :action => "programmes"
  map.testimonials '/services/testimonials', :controller => "pages", :action => "testimonials"
  map.appleaday '/services/appleaday', :controller => "pages", :action => "appleaday"
  map.tree '/services/tree', :controller => "pages", :action => "tree"
  map.yourmind '/services/yourmind', :controller => "pages", :action => "yourmind"

  # Funnel pages
  map.individuals '/foryou', :controller => "pages", :action => "foryou"
  map.business '/business', :controller => "pages", :action => "business"
  map.schools '/schools', :controller => "pages", :action => "schools"
  map.universities '/universities', :controller => "pages", :action => "universities"
  map.communities '/communities', :controller => "pages", :action => "communities"
  map.healthcare '/healthcare', :controller => "pages", :action => "healthcare"

  # Community pages
  map.grow '/grow', :controller => "pages", :action => "join_us"
  map.join_us '/grow/join_us', :controller => "pages", :action => "join_us"
  map.donate '/grow/donate', :controller => "pages", :action => "donate"
  map.partnerships '/grow/partnerships', :controller => "pages", :action => "partnerships"
  map.volunteer '/grow/volunteer', :controller => "pages", :action => "volunteer"
  map.grow_your_own '/grow/grow_your_own', :controller => "pages", :action => "grow_your_own"
  map.events '/grow/events', :controller => "pages", :action => "events"
  map.toolkits '/grow/toolkits', :controller => "pages", :action => "toolkits"
  map.gardeners '/grow/gardeners', :controller => "pages", :action => "gardeners"
  map.international '/grow/international', :controller => "pages", :action => "international"
  map.shop 'grow/shop', :controller => "pages", :action => "shop"

  # Event pages
  map.thebigtreat '/thebigtreat', :controller => "pages", :action => "bigtreat"
  map.feedyourhead '/feedyourhead', :controller => "pages", :action => "feedyourhead"
  map.mindcider '/mindcider', :controller => "pages", :action => "mindcider"
  
  # Research pages
  map.research '/research', :controller => "pages", :action => "research"
  map.feedback '/research/feedback', :controller => "pages", :action => "feedback"
  map.satisfaction '/research/satisfaction', :controller => "pages", :action => "satisfaction"
  map.survey '/research/survey', :controller => "pages", :action => "survey"

  # General
  map.terms '/terms', :controller => "pages", :action => "terms"
  map.privacy '/privacy', :controller => "pages", :action => "privacy"
  map.debug '/debug', :controller => "pages", :action => "debug"
  map.share '/share', :controller => "pages", :action => "share_on_social_media"

  # Shortcut links
  map.shop '/shop', :controller => "pages", :action => "shop"
  map.media '/media', :controller => "pages", :action => "media"
  map.contact '/contact', :controller => "pages", :action => "contact"
  map.donate '/donate', :controller => "pages", :action => "donate"
  map.jobs '/jobs', :controller => "pages", :action => "jobs"
  map.events '/events', :controller => "pages", :action => "events"
  map.tree '/tree', :controller => "pages", :action => "tree"
  map.toolkits '/toolkits', :controller => "pages", :action => "toolkits"
  map.yourmind '/yourmind', :controller => "pages", :action => "yourmind"
  map.feedback '/feedback', :controller => "pages", :action => "feedback"
  map.satisfaction '/satisfaction', :controller => "pages", :action => "satisfaction"
  map.survey '/survey', :controller => "pages", :action => "survey"
  
  # Techie things
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
