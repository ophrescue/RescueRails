set :application, "rescuerails"
set :repository,  "git@github.com:docvego/RescueRails.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, "master"
set :deploy_via, :remote_cache


role :web, "173.255.234.200"                          # Your HTTP server, Apache/etc
role :app, "173.255.234.200"                          # This may be the same as your `Web` server
role :db,  "173.255.234.200", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/#{application}"

set :user, "unicorn"
set :use_sudo, false
ssh_options[:keys] = %w(/Users/mark/.ssh/unicorn)

require "bundler/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p0'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end