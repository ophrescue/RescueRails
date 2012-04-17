# Romain Champourlier © softr.li
# Inspired from many gist, recipes on github, tutorials... essentially:
# - https://gist.github.com/548927
# - http://techbot.me/2010/08/deployment-recipes-deploying-monitoring-and-securing-your-rails-application-to-a-clean-ubuntu-10-04-install-using-nginx-and-unicorn/
# - https://github.com/ricodigo/ricodigo-capistrano-recipes
#
# ONGOING WORK
# MIT License http://www.opensource.org/licenses/mit-license.php
#
# - Intended for Ubuntu 10.04.3
# - Deploy Rails app to be served by an unicorn instance, reverse-proxied by a nginx server
# - Automatically:
#     - generates unicorn.rb conf file,
#     - generates nginx host-file and symlinks it to sites-available and sites-enabled,
#     - generates a startup script to run the unicorn instance when the server is booted,
#     - add the service to the expected runlevels.
#
#
# TODO
# - use CLI for passwords
# - write a remove task

# Common
$:.unshift File.expand_path("..", __FILE__)
require 'capistrano'
require 'capistrano/cli'


# ------------------------------------------------------------------------------- #
# Project-specific
# ------------------------------------------------------------------------------- #

# Below are the parameters you must change to match your app.
server =                    "173.255.234.200"
app_name =                  "rescuerails"
app_repository =            "git@github.com:docvego/RescueRails.git"
app_repository_branch =     "master"
app_deployment_root =       "/var/www/rescuerails"
deployment_user =           "unicorn"
#deployment_user_password =  "PASSWORD"
ssh_options[:keys] = %w(/Users/mark/.ssh/unicorn)
deployment_group =          "unicorn"
rvm_ruby_string =           "ruby-1.9.3-p0@rescuerails"

# You will be asked to enter domain names to deploy to. If you type nothing,
# this value is used.
default_nginx_domains =     "ophrescue.org"

# Below are some parameters you may want/need to change depending on your app
# requirements/server setup.

# Unicorn

# Number of workers (Rule of thumb is 1 per CPU)
# Just be aware that every worker needs to cache all classes and thus eat some
# of your RAM.
set :unicorn_workers,         2           # default: 4
#set :unicorn_workers_timeout, 30         # default: 30

# Nginx
#set :nginx_directory_path, "/etc/nginx"  # default: /etc/nginx
#set :app_port, 80                        # default: 80
#set :app_uses_ssl, false                 # default: false
#set :app_port_ssl, 443                   # default: 443

# ------------------------------------------------------------------------------- #

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.
set :rvm_ruby_string, rvm_ruby_string                   # The RVM's env to run in.
require "rvm/capistrano"                                # Load RVM's capistrano plugin.

require 'bundler/capistrano'

require "delayed/recipes"

set :use_sudo,            false

set :git_shallow_clone,   1 # tell git to clone only the latest revision and not the whole repository
set :keep_releases,       5
after "deploy:update", "deploy:cleanup" 

set :application,         app_name
set :repository,          app_repository
set :branch,              app_repository_branch

set :user,                deployment_user
#set :password,            deployment_user_password
set :group,               deployment_group

set :deploy_to,           app_deployment_root
set :runner,              deployment_user
set :scm,                 :git
set :rails_env,           :production

role :app,                server
role :web,                server
role :db,                 server, :primary => true

load 'deploy/assets'

# Options necessary to make Ubuntu’s SSH happy
ssh_options[:paranoid]    = false
default_run_options[:pty] = true
 
# Shared paths
set :shared_path,           "#{deploy_to}/shared"
set :configs_path,          "#{shared_path}/configs"
set :pids_path,             "#{shared_path}/pids"
set :sockets_path,          "#{shared_path}/sockets"
set :logs_path,             "#{shared_path}/log"

# Deploy hooked callbacks

after 'deploy:setup' do
  sudo "mkdir -p #{configs_path}"
  sudo "mkdir -p #{sockets_path}"
  sudo "chown -R #{user}:#{group} #{configs_path} #{sockets_path}"
  sudo "chmod -R g+w #{configs_path} #{sockets_path}"
  unicorn.setup
  nginx.setup
end

# Link up the config files
before 'deploy:assets:precompile', 'deploy:symlink_configs'

# Delayed Job  
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

# Unicorn setup

# The wrapped bin to start unicorn. This is necessary because we're using rvm.
set :unicorn_binary,      "unicorn"

set :unicorn_config,      "#{configs_path}/unicorn.rb"
set :unicorn_pid,         "#{pids_path}/unicorn.pid"      # Defines where the unicorn pid will live.
set :unicorn_socket,      "#{sockets_path}/unicorn.sock"

set :unicorn_workers,     4 unless exists?(:unicorn_workers)

# Workers timeout in the amount of seconds below, when the master kills it and
# forks another one.
set :unicorn_workers_timeout, 30 unless exists?(:unicorn_workers_timeout)

# Workers are started with this user/group
# By default we get the user/group set in capistrano.
set(:unicorn_user) { user }   unless exists?(:unicorn_user)
set(:unicorn_group) { group } unless exists?(:unicorn_group)

# The unicorn template to be parsed by erb. You must copy this file to your app's vendor directory
# (vendor/unicorn_template.rb.erb). Capistrano will search it locally, so you don't need to track it
# in git. However, it may be helpful to have in there so anybody can use it to deploy.
set :unicorn_template,                "vendor/unicorn_template.rb.erb"
set :unicorn_startup_script_template, "vendor/unicorn_startup_script_template.erb"
set :startup_script_prefix,           "/etc/init.d"
set :startup_script_name,             "unicorn_#{app_name}"
set :startup_script_path,             "#{startup_script_prefix}/#{startup_script_name}"
set :unicorn_runlevels,               "2 3 4 5"
set :unicorn_stoplevels,              "0 1 6"
set :unicorn_startorder,              "21"
set :unicorn_killorder,               "19"
  
# Unicorn deployment tasks
namespace :unicorn do
  desc "Starts unicorn directly"
  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  desc "Stops unicorn directly"
  task :stop, :roles => :app do
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end

  desc "Restarts unicorn directly"
  task :restart, :roles => :app do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end

  desc "Gracefully stops unicorn directly"
  task :graceful_stop, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  
  desc <<-EOF
  Create the unicorn configuration file from the template and \
  uploads the result to #{unicorn_config}, to be loaded by whoever is booting \
  up the unicorn.
  EOF
  task :setup, :roles => :app , :except => { :no_release => true } do
    generate_config(unicorn_template, unicorn_config)
    
    # Generate the startup script and move it to the init.d dir (or any other directory specified
    # by startup_script_prefix). Also set the correct rights.
    generate_config(unicorn_startup_script_template, "#{shared_path}/#{startup_script_name}")
    sudo "mv #{shared_path}/#{startup_script_name} #{startup_script_path}"
    sudo "chown root:root #{startup_script_path}"
    sudo "chmod 0755 #{startup_script_path}"
    
    # Position the script for loading at server's boot.
    #sudo "update-rc.d #{startup_script_name} defaults"
    sudo "update-rc.d #{startup_script_name} start #{unicorn_startorder} #{unicorn_runlevels} . stop #{unicorn_killorder} #{unicorn_stoplevels} ."
  end
end

# nginx setup
set :nginx_directory_path,  "/etc/nginx" unless exists?(:nginx_directory_path)
set :app_port, 80 unless exists?(:app_port)
set :app_uses_ssl, false unless exists?(:app_uses_ssl)
set :app_port_ssl, 443 unless exists?(:app_port_ssl)

# The nginx template to be parsed by erb. You must copy this file to your app's vendor directory
# (vendor/nginx_template.rb.erb). Capistrano will search it locally, so you don't need to track it
# in git. However, it may be helpful to have in there so anybody can use it to deploy.
set :nginx_template,    "vendor/nginx_template.rb.erb"
set :nginx_host_config, "#{configs_path}/#{app_name}.tld"

# Nginx tasks are not *nix agnostic, they assume you're using Debian/Ubuntu.
# Override them as needed.
namespace :nginx do
  
  desc "Parses and uploads nginx configuration for this app"
  task :setup, :roles => :app , :except => { :no_release => true } do
    set :nginx_domains, Capistrano::CLI.ui.ask("Enter #{application} domain names:") { |q| q.default = default_nginx_domains}
    generate_config(nginx_template, nginx_host_config)
    sudo "ln -s #{nginx_host_config} #{nginx_directory_path}/sites-available/"
    sudo "ln -s #{nginx_host_config} #{nginx_directory_path}/sites-enabled/"
  end

  desc "Parses config file and outputs it to STDOUT (internal task)"
  task :parse, :roles => :app , :except => { :no_release => true } do
    puts parse_config(nginx_template)
  end

  desc "Reload nginx. Send the HUP signal to have nginx reload its configuration"
  task :reload, :roles => :app , :except => { :no_release => true } do
    sudo "service nginx reload"
  end

  desc "Restart nginx"
  task :restart, :roles => :app , :except => { :no_release => true } do
    sudo "service nginx restart"
  end

  desc "Stop nginx"
  task :stop, :roles => :app , :except => { :no_release => true } do
    sudo "service nginx stop"
  end

  desc "Start nginx"
  task :start, :roles => :app , :except => { :no_release => true } do
    sudo "service nginx start"
  end

  desc "Show nginx status"
  task :status, :roles => :app , :except => { :no_release => true } do
    sudo "service nginx status"
  end
end

namespace :deploy do

  desc "Deploy and migrate the database - this will cause downtime during migrations"
  task :migrations do
    transaction do
      update_code
      web:disable
      migrate
      web:enable
    end
    restart
  end

  desc "Symlinks setup_mail.rb, newrelic.yml, database.yml"
  task :symlink_configs, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/configs/newrelic.yml #{release_path}/config/newrelic.yml"
    run "ln -nfs #{deploy_to}/shared/configs/initializers/setup_mail.rb #{release_path}/config/initializers/setup_mail.rb"
    run "ln -nfs #{deploy_to}/shared/configs/initializers/mailchimp.rb #{release_path}/config/initializers/mailchimp.rb"
    run "ln -nfs #{deploy_to}/shared/configs/database.yml #{release_path}/config/database.yml"
  end

  # Invoked during initial deployment
  desc "start"
  task :start, :roles => :app, :except => {:no_release => true} do
    unicorn.start
    nginx.restart # reload seems not to suffice
  end

  desc "stop"
  task :stop, :roles => :app, :except => {:no_release => true} do
    unicorn.stop
  end
  
  desc "reload"
  task :reload, :roles => :app, :except => {:no_release => true} do
    unicorn.reload
  end
  
  desc "graceful stop"
  task :graceful_stop, :roles => :app, :except => {:no_release => true} do
    unicorn.graceful_stop
  end
  
  # Invoked after each deployment afterwards
  desc "restart"
  task :restart do
    stop
    start
  end
end

namespace :deploy do
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read("./app/views/layouts/maintenance.html.erb")
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end
end


def parse_config(file)
  puts File.expand_path(File.dirname(__FILE__))
  require 'erb' # render not available in Capistrano 2
  template = File.read(file) # read it
  return ERB.new(template).result(binding) # parse it
end

# Generates a configuration file parsing through ERB
# Fetches local file and uploads it to remote_file
# Make sure your user has the right permissions.
def generate_config(local_file, remote_file)
  temp_file = '/tmp/' + File.basename(local_file)
  buffer    = parse_config(local_file)
  File.open(temp_file, 'w+') { |f| f << buffer }
  upload temp_file, remote_file, :via => :scp
  `rm #{temp_file}`
end