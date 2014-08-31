# If you're unfortunate enough to be developing in Windows, bundle with:
# bundle install --without-production

source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '~> 3.2.19'

gem 'dotenv'
gem 'dotenv-deployment'
gem 'pg', '~> 0.14.1'
gem 'will_paginate',  '~> 3.0.3'
gem 'bootstrap-will_paginate', '~> 0.0.7'
gem 'gravatar_image_tag', '~> 1.1.2'
gem 'rails3-jquery-autocomplete', '~> 1.0.7'
gem 'paperclip', '~> 4.1.1'
gem 'aws-sdk', '~> 1.39.0'
gem 'therubyracer', '~> 0.11.3', platform: :ruby
gem 'geocoder', '~> 1.1.1'
gem 'best_in_place', '~> 2.0.3'
gem 'gibbon', '~> 1.1.1'
gem 'exception_notification', '~> 3.0.1'
gem 'acts_as_list', '~> 0.1.8'
gem 'strip_attributes', '~> 1.0'
gem 'to_xls'
gem 'roo'
gem 'font-awesome-rails', '~> 4.1.0.0'
gem 'has_scope'

group :production do
  gem 'unicorn', '~> 4.6.0'
end

# Cool mail async stuff
gem 'daemons', '~> 1.1.8'
gem 'delayed_job', '~> 3.0.3'
gem 'delayed_job_active_record'
gem 'mailhopper', '~> 0.3.0'
gem 'delayed_mailhopper', '~> 0.0.7'

gem 'anjlab-bootstrap-rails', '~> 2.2.2.1', require: 'bootstrap-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'chosen-rails', '~> 1.0.2'
gem 'jquery-rails', '~> 2.0.3'
gem 'jquery-ui-rails', '~> 2.0.2'

gem 'newrelic_rpm'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

group :development, :test do
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'watir-webdriver', platform: :ruby
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara', '~> 2.1.0'
  gem 'database_cleaner'
end

group :development do
  gem 'capistrano', '~> 3.1.0'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'quiet_assets'
  gem 'annotate'
  gem 'powder'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end
