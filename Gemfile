# If you're unfortunate enough to be developing in Windows, bundle with:
# bundle install --without-production

source 'https://rubygems.org'

gem 'rails', '~> 3.2.17'

gem 'dotenv-rails'
gem 'pg', '~> 0.14.1'
gem 'will_paginate',  '~> 3.0.3'
gem 'bootstrap-will_paginate', '~> 0.0.7'
gem 'gravatar_image_tag', '~> 1.1.2'
gem 'rails3-jquery-autocomplete', '~> 1.0.7'
gem 'paperclip', '~> 3.0'
gem 'therubyracer', '~> 0.11.3', platform: :ruby
gem 'geocoder', '~> 1.1.1'
gem 'best_in_place', '~> 2.0.3'
gem 'gibbon', '~> 1.1.1'
gem 'exception_notification', '~> 3.0.1'
gem 'acts_as_list', '~> 0.1.8'
gem 'strip_attributes', '~> 1.0'
gem 'to_xls'
gem 'roo'

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

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'
gem 'capistrano-maintenance', '~> 0.0.2'

group :development, :test do
  gem 'rspec-rails'
  gem 'watir-webdriver', platform: :ruby
  gem 'faker'
end

group :test do
  gem 'factory_girl_rails'
  gem 'watir-webdriver', :platform => :ruby
  gem "capybara", "~> 2.1.0"
  gem 'faker'
end

group :development do
  gem 'quiet_assets'
  gem 'annotate'
  gem 'powder'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end
