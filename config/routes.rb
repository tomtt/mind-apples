ActionController::Routing::Routes.draw do |map|
  # Resources
  map.resource :user_session
  map.resources :people, :as => "person", :except => [:index]
  map.resources :password_resets

  # Named routes
  map.root :controller => "pages", :action => "home"
  map.login '/login', :controller => "user_sessions", :action => "new"
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  # Individual pages
  map.about '/about', :controller => "pages", :action => "about"
  map.team '/about/team', :controller => "pages", :action => "team"
  map.fives '/fives', :controller => "pages", :action => "fives"
  map.help_us_grow '/help-us-grow', :controller => "pages", :action => "help_us_grow"
  map.links '/links', :controller => "pages", :action => "links"

  # Generic routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
