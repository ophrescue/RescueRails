source 'https://rubygems.org'
ruby   '2.5.1'

gem 'rails', '~> 5.2.1'

gem 'rack-cache'

gem 'audited', '~> 4.5'
gem 'aws-sdk', '~> 2'
gem 'bootstrap', '~> 4.1.0'
gem 'bootstrap-will_paginate', '~> 1.0.0'
gem 'clearance'
gem 'countries'
gem 'dotenv'
gem 'dotenv-rails'
gem 'exception_notification'
gem 'exception_notification-rake', '~> 0.3.0'
gem 'font-awesome-rails'
gem 'geocoder'
gem 'gibbon'
gem 'gravatar_image_tag'
gem 'has_scope'
gem 'paperclip', '~> 5'
gem 'rails4-autocomplete'
gem 'record_tag_helper', '~> 1.0'
gem 'redcarpet'
gem 'responders'
gem 'strip_attributes'
gem 'stripe'
gem 'to_xls'
gem 'whenever', '~> 0.9.4', require: false
gem 'will_paginate'

# datas
gem 'dalli'
gem 'pg', '~> 0.21.0'

group :production do
  gem 'unicorn'
end

# Cool mail async stuff
gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails'
gem 'mini_racer', platforms: :ruby
gem 'uglifier'

gem 'newrelic_rpm'
# Rollbar can pick up new versions after this issue is fixed
# https://github.com/rollbar/rollbar-gem/issues/713
gem 'rollbar', '2.15.5'
gem 'sucker_punch', '~> 1.5.1'
gem 'factory_bot_rails'

group :development, :test do
  gem 'faker'
  gem 'flamegraph'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'rack-mini-profiler', require: false
  gem 'rspec-collection_matchers'
  gem 'rspec-rails'
  gem 'puma'
  gem 'stackprof'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rack_session_access'
  gem 'browserstack-local'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano-rails', '~> 1.1.5'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', '~> 2.0.3'
  gem 'powder'
  gem 'rubocop'
  gem 'rubocop-rspec'
end
