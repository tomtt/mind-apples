set :application, "mindapples"
set :repository,  "."

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :user, "tomtt"
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

after "deploy:update_code", "config:copy_shared_configurations"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  db_params = {
    "adapter"=>"mysql",
    "database"=>"#{application}_#{rails_env}",
    "username"=>"root",
    "password"=>"",
    "host"=>"localhost",
    "socket"=>""
  }

  db_params.each do |param, default_val|
    set "db_#{param}".to_sym,
    lambda { Capistrano::CLI.ui.ask "Enter database #{param}" do |q|
        q.default=default_val end}
  end

  task :my_generate_database_yml, :roles => :app do
    database_configuration = "#{rails_env}:\n"
    db_params.each do |param, default_val|
      val=self.send("db_#{param}")
      database_configuration<<"  #{param}: #{val}\n"
    end
    run "mkdir -p #{deploy_to}/#{shared_dir}/config"
    put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml"
  end
end

# Configuration Tasks
namespace :config do
  desc "copy shared configurations to current"
  task :copy_shared_configurations, :roles => [:app] do
    %w[database.yml].each do |f|
      run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
  end
end
