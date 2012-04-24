## If you're unfortunate enough to be developing in Windows, bundle with:
## bundle install --without-production 
##
source 'http://rubygems.org'

gem 'rails', '3.1.3'

gem 'pg'
gem 'will_paginate',  '~> 3.0.2'
gem 'bootstrap-will_paginate'
gem 'gravatar_image_tag'
gem 'rails3-jquery-autocomplete'
gem "paperclip"
gem 'therubyracer', :platform => :ruby
gem 'geocoder'
gem 'best_in_place'
gem 'gibbon'

group :production do
  gem 'unicorn'
end


# Cool mail async stuff
gem "delayed_job", "~> 2.1.4"
gem 'mailhopper'
gem 'delayed_mailhopper'


gem 'anjlab-bootstrap-rails', '1.4.0.14', :require => 'bootstrap-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'newrelic_rpm'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Deploy with Capistrano
  gem 'capistrano'

group :development do
  gem 'rspec-rails'
  gem 'annotate'
  gem 'faker'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'turn', :require => false
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem 'autotest-fsevent' , :platform => :ruby
  gem 'autotest-growl' , :platform => :ruby  
end

group :test do
  gem 'rspec-rails'
  gem 'webrat'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'turn', :require => false
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem 'autotest-fsevent', :platform => :ruby
  gem 'autotest-growl', :platform => :ruby
end