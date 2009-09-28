set :rails_env, "production"

set :rails_server, "209.41.75.7"

role :app, rails_server
role :web, rails_server
role :db,  rails_server, :primary => true

set :ruby_vm_type,      :mri        # :ree, :mri
set :web_server_type,   :apache     # :apache, :nginx
set :app_server_type,   :passenger  # :passenger, :mongrel
set :db_server_type,    :mysql      # :mysql, :postgresql, :sqlite
