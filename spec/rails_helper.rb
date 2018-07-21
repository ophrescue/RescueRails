ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Capybara integration
require 'capybara/rspec'
require 'capybara/rails'

require 'capybara-screenshot/rspec'

require 'selenium/webdriver'

# Headless Chrome
Capybara.register_driver :selenium_chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1366,2000] }
  )
  Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
end

Capybara.register_driver :selenium_firefox_headless do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('-headless')
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :options => options)
end

Capybara::Screenshot.register_driver(:selenium_firefox_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

if ENV['BROWSER'] == 'firefox'
  puts 'testing with firefox headless'
  Capybara.javascript_driver = :selenium_firefox_headless
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
