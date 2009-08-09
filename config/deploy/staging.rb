set :user, "mindapples"
set :deploy_to, "/home/#{user}/deploy/#{application}"
set :use_sudo, false

set :repository, "git://github.com/tomtt/mind-apples.git"
ssh_options[:forward_agent] = true
set :scm, :git
set :scm_verbose, true # due to git 1.4 being used on server
set :branch, "master"
set :deploy_via, :remote_cache

set :copy_remote_dir, "/home/#{user}"

set :host, "216.194.126.27"
role :app, host
role :web, host
role :db,  host, :primary => true
