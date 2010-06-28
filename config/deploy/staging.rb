set :rails_env, "staging"

set :user, "mapples"
set :deploy_to, "/home/#{user}/#{application}"
set :rails_server, "mindapples.staging.unboxedconsulting.com"

role :app, rails_server
role :web, rails_server
role :db,  rails_server, :primary => true
