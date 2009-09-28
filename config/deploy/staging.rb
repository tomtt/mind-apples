set :rails_env, "staging"

set :rails_server, "mindapples.staging.tomtenthij.co.uk"

role :app, rails_server
role :web, rails_server
role :db,  rails_server, :primary => true
