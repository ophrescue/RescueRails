ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'clearance/rspec'

# Capybara integration
require 'capybara/rspec'
require 'capybara/cuprite'
require 'capybara/rails'
require 'capybara-screenshot/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  cuprite_options = {
    window_size: [1200, 800],
    process_timeout: 60,
    timeout: 60,
    browser_options: {
      'no-sandbox' => nil,
      'disable-dev-shm-usage' => nil
    }
  }

  # In the devcontainer, Chromium is installed via Playwright and symlinked
  # here (Google Chrome ships no arm64 build). Falls back to Ferrum's own
  # auto-detection when running outside the container.
  chrome_path = ENV['CHROME_PATH'] || '/usr/local/bin/chromium'
  cuprite_options[:browser_path] = chrome_path if File.exist?(chrome_path)

  Capybara::Cuprite::Driver.new(app, **cuprite_options)
end

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include LoginMacros
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods

  # Disable Rails transactional fixtures in favor of DatabaseCleaner
  config.use_transactional_fixtures = false

  # Attempt to automatically mix in behaviours based on file location
  # i.e. `get`, `post` in controller specs
  config.infer_spec_type_from_file_location!
end

# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run

Capybara.asset_host="http://localhost:3000/assets"
