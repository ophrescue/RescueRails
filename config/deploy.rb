# config valid only for Capistrano 3.1
# Source: http://www.talkingquickly.co.uk/2014/01/deploying-rails-apps-to-a-vps-with-capistrano-v3/
lock '3.11.0'

set :application, 'RescueRails'
set :deploy_user, 'deploy'

# setup repo details
set :repo_url, 'git@github.com:ophrescue/RescueRails.git'

set :default_environment, { 'PATH' => '/home/deploy/.rbenv/shims:/home/deploy/.rbenv/bin:$PATH' }

set :direct_rbenv_path, '/home/deploy/.rbenv'

# setup rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:direct_rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:direct_rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

#how many old releases we want to keep
set :keep_releases, 5

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false, use passwordless sudo
set :pty, false

set :newrelic_license_key, ENV['NEW_RELIC_LICENSE_KEY']

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
#If you were to have this as set :tests, []
# then bundle exec rspec spec would be run and would
# have to pass before deployment would continue.
#
set :tests, []

# files we want symlinking to specific entries in shared.
set :linked_files, %W{config/database.yml
                      config/newrelic.yml
                      config/initializers/setup_mail.rb
                      config/unicorn.rb
                      .env.#{fetch(:stage)} }

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w[nginx.conf
                      log_rotation
                      monit
                      unicorn.rb])


# link cap managed config files to elsewhere in the server
set(:etclinks, [
  {
    link: "/etc/nginx/sites-enabled/rescuerails.conf",
    source: "config/nginx.conf"
  }
])

# Reference config files provided by Ansible
set(:symlinks, [
  {
    link: "config/database.yml",
    source: "/var/www/rescuerails_ansible/config/database.yml"
  },
  {
    link: ".env.#{fetch(:stage)}",
    source: "/var/www/rescuerails_ansible/config/.env.#{fetch(:stage)}"
  },
  {
    link: "config/initializers/setup_mail.rb",
    source: "/var/www/rescuerails_ansible/config/setup_mail.rb"
  },
  {
    link: "config/newrelic.yml",
    source: "/var/www/rescuerails_ansible/config/newrelic.yml"
  }
])

set :systemd_delayed_job_instances, ->{ 3.times.to_a }

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  before :deploy, "deploy:run_tests"
  ## compile assets locally then rsync
  #after 'deploy:symlink:shared', 'deploy:compile_assets'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations
  # we've added
  after 'deploy:setup_config', 'monit:restart'

  after 'deploy:restart', 'systemd:unicorn:reload-or-restart'
  after 'deploy:restart', 'systemd:delayed_job:restart'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end
