require 'simplecov'
require 'coveralls'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start 'rails'

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

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_files/"])
  end
end
