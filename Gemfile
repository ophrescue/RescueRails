source 'https://rubygems.org'
ruby   '2.6.6'

gem 'rails', '~> 6.0.3.4'

gem 'rack-cache'

gem 'audited', '~> 4.5'
gem 'aws-sdk', '~> 2'
gem 'bootstrap', '~> 4.3.1'
gem 'bootstrap-will_paginate', '~> 1.0.0'
gem "chartkick"
gem 'clearance'
gem 'countries'
gem 'dotenv'
gem 'dotenv-rails'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.3'
gem 'geocoder'
gem 'gibbon'
gem 'gravatar_image_tag'
gem 'groupdate'
gem 'has_scope'
gem 'paperclip', '~> 5'
gem 'rails4-autocomplete'
gem 'record_tag_helper', '~> 1.0'
gem 'redcarpet'
gem 'responders'
gem 'strip_attributes'
gem 'stripe'
gem 'to_xls'
gem 'webpacker', '~> 5.2', '>= 5.2.1'
gem 'wicked_pdf'
gem 'whenever', '~> 0.9.4', require: false
gem 'will_paginate'

# datas
gem 'dalli'
gem 'pg', '~> 0.21.0'

group :production do
  gem "unicorn", "~> 5.5.0.1.g6836"
end

# Cool mail async stuff
gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'

# Gems used only for assets and not required
# in production environments by default.

gem 'sassc', '~> 2.4'
gem 'mini_racer', '>= 0.2.3', platforms: :ruby
gem 'uglifier'

gem 'newrelic_rpm'
gem 'honeybadger', '~> 4.0'
gem 'sucker_punch', '~> 1.5.1'
gem 'factory_bot_rails'
gem 'exception_notification'

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
  gem 'webdrivers'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rack_session_access'
  gem 'browserstack-local'
  gem 'simplecov',      require: false
  gem 'simplecov-lcov', require: false
  gem 'stripe-ruby-mock', '~> 2.5.4', :require => 'stripe_mock'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano-rails', '~> 1.1.5'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', '~> 2.0.3'
  gem 'capistrano-systemd-multiservice', require: false
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'powder'
  gem 'rubocop'
  gem 'rubocop-rspec'
end
