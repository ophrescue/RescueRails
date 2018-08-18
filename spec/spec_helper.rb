require 'simplecov'
require 'coveralls'
require "rack_session_access/capybara"
require 'faker'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'rails'

Faker::Config.random = Random.new(RSpec.configuration.seed)

RSpec.configure do |config|
  # Use documentation formatter when running a single file.
  config.default_formatter = 'doc' if config.files_to_run.one?


  # Print the 5 slowest examples and example groups at the end of the run
  config.profile_examples = 5

  # Run specs in random order, use --seed 1234 to specifiy a seed
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax
    # http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  config.before(:suite) do
    # required for TravisCI, otherwise this required sequence is not present in the db
    ActiveRecord::Base.connection.execute("DROP SEQUENCE IF EXISTS tracking_id_seq;")
    ActiveRecord::Base.connection.execute("CREATE SEQUENCE tracking_id_seq START 1;")
    `RAILS_ENV=test rake assets:precompile 2>/dev/null` # inhibit STD_OUT b/c it overruns the terminal page
  end

  config.before :each, type: :feature do
    begin
      handle = page.driver.current_window_handle
      # added for Browserstack IE, which opens windows with unpredictable size
      page.driver.maximize_window(handle)
    rescue Capybara::NotSupportedByDriverError
    end
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_files/"])
    FileUtils.rm_rf(Dir[Rails.root.join('public', 'system', 'test')])
    FileUtils.rm_rf(Dir[Rails.root.join('public', 'assets', '*')])
    FileUtils.rm(Dir[Rails.root.join('public', 'assets', '.sprockets*')])
  end

  config.define_derived_metadata(:file_path => Regexp.new('/spec/rake/')) do |metadata|
    metadata[:type] = :model
  end
end
