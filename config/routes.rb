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
  map.things_to_do '/things-to-do', :controller => "pages", :action => "things_to_do"
  map.help_us_grow '/help-us-grow', :controller => "pages", :action => "help_us_grow"
  map.about_us '/about-us', :controller => "pages", :action => "about_us"
  map.social_media_stuff '/social_media_stuff', :controller => "pages", :action => "social_media_stuff"
end
