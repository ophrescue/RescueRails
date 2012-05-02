## If you're unfortunate enough to be developing in Windows, bundle with:
## bundle install --without-production 
##
source 'http://rubygems.org'

gem "rails", "~> 3.2.3"

gem "pg", "~> 0.13.2"
gem 'will_paginate',  '~> 3.0.2'
gem 'bootstrap-will_paginate', "~> 0.0.3"
gem "gravatar_image_tag", "~> 1.1.2"
gem "rails3-jquery-autocomplete", "~> 1.0.7"
gem "paperclip", "~> 2.4.5"
gem "therubyracer", "~> 0.10.1", :platform => :ruby
gem "geocoder", "~> 1.1.1"
gem "best_in_place", "~> 1.0.6"
gem "gibbon", "~> 0.3.5"
gem "exception_notification", "~> 2.6.1"

group :production do
  gem "unicorn", "~> 4.3.0"
end


# Cool mail async stuff
gem "delayed_job", "~> 2.1.4"
gem "mailhopper", "~> 0.1.0"
gem "delayed_mailhopper", "~> 0.0.5"


gem 'anjlab-bootstrap-rails', '1.4.0.14', :require => 'bootstrap-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem "jquery-rails", "~> 2.0.2"

gem "newrelic_rpm", "~> 3.3.4.1"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Deploy with Capistrano
gem "capistrano", "~> 2.12.0"

group :development do
  gem 'rspec-rails'
  gem 'annotate'
  gem 'faker'
  gem 'debugger', :require => 'ruby-debug'
  gem 'turn', :require => false
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem "autotest-fsevent", "~> 0.2.8" , :platform => :ruby
  gem 'autotest-growl' , :platform => :ruby  
  gem "thin", "~> 1.3.1"
end

group :test do
  gem 'rspec-rails'
  gem 'webrat'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'debugger', :require => 'ruby-debug'
  gem 'turn', :require => false
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem "autotest-fsevent", "~> 0.2.8" , :platform => :ruby
  gem 'autotest-growl', :platform => :ruby
  gem "thin", "~> 1.3.1"
end