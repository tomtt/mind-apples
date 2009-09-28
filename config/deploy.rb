require 'deprec'

set :stages, %w(staging production)
set :default_stage, "staging"

set :application, "mindapples"
set :user, "mindapples"

set :deploy_to, "/home/#{user}/#{application}"

begin
  require 'capistrano/ext/multistage'
rescue LoadError
  puts "Could not load capistrano multistage extension.  Make sure you have installed the capistrano-ext gem"
end

set :scm, :git
set :repository, "git://github.com/tomtt/mind-apples.git"
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache

set :use_sudo, false
# set :scm_verbose, true # due to git 1.4 being used on server
# set :branch, "master"
# set :copy_remote_dir, "/home/#{user}"

# after "deploy:update_code", "config:copy_shared_configurations"
# after "deploy", "features:generate_feature_html_files"

namespace :deploy do

  after "deploy:setup", "deploy:initial_setup"
  task :initial_setup do
    run "mkdir -p #{shared_path}/config"
    put(File.read(File.join(File.expand_path(File.dirname(__FILE__)), "database.yml.example")),
        "#{shared_path}/config/database.yml",
        :mode => 0600)
  end

  after "deploy:update_code", "deploy:symlink_configs"
  task :symlink_configs do
    run "ln -fs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end

  # Clean up old releases (by default keeps last 5)
  after "deploy:update_code", "deploy:cleanup"

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  namespace :web do

    # before "deploy", "deploy:web:disable"
    # before "deploy:migrations", "deploy:web:disable"

    desc "Present a maintenance page to visitors."
    task :disable, :roles => :web, :except => { :no_release => true } do
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      run "cp #{current_path}/public/maintenance/maintenance.html #{shared_path}/system/"
    end

    # after "deploy", "deploy:web:enable"
    # after "deploy:migrations", "deploy:web:enable"
    # Default web:enable task is fine

  end
end

#   db_params = {
#     "adapter"=>"mysql",
#     "database"=>"#{application}_production",
#     "username"=>"root",
#     "password"=>"",
#     "host"=>"localhost",
#     "socket"=>""
#   }
# 
#   db_params.each do |param, default_val|
#     set "db_#{param}".to_sym,
#     lambda { Capistrano::CLI.ui.ask "Enter database #{param}" do |q|
#         q.default=default_val end}
#   end
# 
#   task :my_generate_database_yml, :roles => :app do
#     database_configuration = "production:\n"
#     db_params.each do |param, default_val|
#       val=self.send("db_#{param}")
#       database_configuration<<"  #{param}: #{val}\n"
#     end
#     run "mkdir -p #{deploy_to}/#{shared_dir}/config"
#     put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml"
#   end
# end
# 
# # Configuration Tasks
# namespace :config do
#   desc "copy shared configurations to current"
#   task :copy_shared_configurations, :roles => [:app] do
#     %w[database.yml].each do |f|
#       run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
#     end
#   end
# end
