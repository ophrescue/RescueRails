source 'https://rubygems.org'
ruby   '2.3.1'

gem 'rails', '~> 4.2.4'
gem 'rack-cache'

gem 'acts_as_list', '~> 0.7.2'
gem 'aws-sdk', '>= 2.0.34'
gem 'bootstrap-will_paginate', '~> 0.0.10'
gem 'dotenv'
gem 'dotenv-rails'
gem 'exception_notification'
gem 'font-awesome-rails'
gem 'geocoder', '~> 1.2.13'
gem 'gibbon'
gem 'gravatar_image_tag', '~> 1.2.0'
gem 'has_scope'
gem 'paperclip', '~> 5.0.0'
gem 'rails4-autocomplete'
gem 'responders', '~> 2.0'
gem 'roo', '~>1.13.2'
gem 'strip_attributes', '~> 1.0'
gem 'therubyracer', '~> 0.12.2', platform: :ruby
gem 'to_xls'
gem 'whenever', '~> 0.9.4', require: false
gem 'will_paginate', '~> 3.0.7'

# datas
gem 'dalli'
gem 'pg'

group :production do
  gem 'unicorn'
end

# Cool mail async stuff
gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'mailhopper'
gem 'delayed_mailhopper'

gem 'anjlab-bootstrap-rails', '~> 2.2.2.1', require: 'bootstrap-rails'

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails'
gem 'uglifier'

gem 'chosen-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'newrelic_rpm'
gem 'rollbar'
gem 'sucker_punch', '~> 1.5.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

group :development, :test do
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'rspec-rails'
  gem 'json_spec'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'coveralls', require: false
  gem 'poltergeist'
  gem 'capybara-screenshot'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano-rails', '~> 1.1.5'
  gem 'capistrano-rbenv', '~> 2.0.3'
  gem 'delorean'
  gem 'meta_request'
  gem 'powder'
  gem 'quiet_assets'
  gem 'rubocop'
end
