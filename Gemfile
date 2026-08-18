source 'https://rubygems.org'
ruby   '3.3.12'

gem 'rails', '~> 7.2.0'

gem 'rack-cache'

gem 'audited', '~> 5.0'
gem 'aws-sdk-locationservice', '~> 1.51'
gem 'aws-sdk-s3', '~> 1.116'
gem 'bootstrap', '>= 4.6.2.1', '< 4.7'
gem 'bootstrap-will_paginate', '~> 1.0.0'
gem "chartkick"
gem 'clearance', '~> 2.11.0'
gem 'countries', '~> 4.2', '>= 4.2.3'
gem 'dotenv'
gem 'dotenv-rails'
# erb 6.0.0 dropped ERB.new's legacy positional args (safe_level,
# trim_mode) entirely -- capistrano-systemd-multiservice 0.1.0.beta13
# still calls `ERB.new(str, nil, 2)` and raises ArgumentError on any
# systemd:*:setup task under erb >= 6. Pin below the breaking major
# version until that gem (unmaintained beta) ships a fix.
#
# Within that constraint, pin to the >= 4.0.4.1 patch for
# CVE-2026-41316 (GHSA-q339-8rmv-2mhv, ERB @_init deserialization guard
# bypass) -- the fix was backported to the 4.0.x branch and to 6.0.1.1+,
# but never to 5.x, so 5.1.3 (previously resolved here) has no patched
# release and must be downgraded rather than upgraded.
gem 'erb', '~> 4.0', '>= 4.0.4.1', '< 6'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.3'
gem 'geocoder', "1.8.2" # locked to 1.8.2 until county lookup issue is fixed
gem 'gibbon'
gem 'gravatar_image_tag'
gem 'groupdate'
gem 'has_scope'
gem 'mjml-rails', '~> 4.6', '>= 4.6.1'
gem 'mrml'
gem 'net-ftp'
gem 'kt-paperclip', '~> 7.2'
gem 'rails4-autocomplete'
gem "recaptcha"
gem 'record_tag_helper', '~> 1.0'
gem 'redcarpet'
gem 'responders'
gem 'rest-client', '~> 2.1'
gem 'strip_attributes'
gem 'stripe', '~> 8.7'
gem 'to_xls'
gem 'jsbundling-rails'
gem 'wicked_pdf'
gem 'whenever', '~> 0.9.4', require: false
gem 'will_paginate', '~> 3.3.1'

# datas
gem 'dalli'
gem 'pg', '~> 1.5', '>= 1.5.9'

gem 'puma', '~> 8.0'
# connection_pool 3.0 made ConnectionPool#initialize keyword-only, breaking
# activesupport 7.2's MemCacheStore#build_mem_cache, which still calls it
# with a positional options Hash. Pin below the breaking major version until
# a Rails release calls it with **pool_options instead.
gem 'connection_pool', '< 3.0'

group :production do
  gem 'unicorn', '~> 6.1'
end

# Cool mail async stuff
gem 'daemons'
gem 'delayed_job'
gem 'delayed_job_active_record'

# Gems used only for assets and not required
# in production environments by default.

gem 'sassc', '~> 2.4'
gem 'sassc-rails'
gem 'mini_racer', '>= 0.2.3', platforms: :ruby
gem 'uglifier'

gem 'newrelic_rpm'
gem 'honeybadger', '~> 5.1'
gem 'sucker_punch', '~> 1.5.1'
gem 'factory_bot_rails'

group :development, :test do
  gem 'faker'
  gem 'flamegraph'
  gem 'parallel_tests'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-stack_explorer'
  gem 'rack-mini-profiler', require: false
  gem 'rspec-collection_matchers'
  gem 'rspec-rails', '~> 6.1.0'
  gem 'stackprof'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'cuprite'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rack_session_access'
  gem 'simplecov',      require: false
  gem 'simplecov-lcov', require: false
  gem 'stripe-ruby-mock', '~> 2.5.4', :require => 'stripe_mock'
end

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-bundler', '~> 2.2'
  gem 'capistrano-maintenance', '~> 1.2', require: false
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', '~> 2.0.3'
  gem 'capistrano-systemd-multiservice', require: false
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'powder'
  gem 'bundler-audit'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rubocop-rails'
  gem 'rubocop-performance'
  gem 'ruby-lsp', require: false
end
