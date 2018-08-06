ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Capybara integration
require 'capybara/rspec'
require 'capybara/rails'

require 'capybara-screenshot/rspec'

require 'selenium/webdriver'
require 'drivers/selenium_chrome_headless'
require 'drivers/selenium_firefox_headless'
require 'drivers/selenium_firefox'

if ENV['BROWSER'] == 'firefox_headless'
  puts 'testing with firefox headless'
  Capybara.javascript_driver = :selenium_firefox_headless
elsif ENV['BROWSER'] == 'firefox'
  puts 'testing with firefox'
  Capybara.javascript_driver = :selenium_firefox
elsif ENV['BROWSER'] == 'chrome_headless'
  puts 'testing with chrome headless'
  Capybara.javascript_driver = :selenium_chrome_headless
else
  puts 'testing with chrome headless'
  Capybara.javascript_driver = :selenium_chrome_headless
end

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include LoginMacros
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods, type: :request

  # Disable Rails transactional fixtures in favor of DatabaseCleaner
  config.use_transactional_fixtures = false

  # Attempt to automatically mix in behaviours based on file location
  # i.e. `get`, `post` in controller specs
  config.infer_spec_type_from_file_location!
end

# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run

Capybara.asset_host="http://localhost:3000/assets"
