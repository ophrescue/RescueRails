require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Capybara integration
require 'capybara/rspec'
require 'capybara/rails'

require 'capybara-screenshot/rspec'

#Poltergeist with PhantomJS
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus


  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include FactoryGirl::Syntax::Methods
  config.include JsonSpec::Helpers

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, type: :request) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

#Use this method to simulate keypress entries
# https://github.com/thoughtbot/capybara-webkit/issues/303
def send_keys_inputmask(location, keys)
  len = keys.length - 1
  find(location).click
  (0..keys.length - 1).each_with_index do |e,i|
    find(location).native.send_keys keys[i]
  end
end

class User
  def chimp_subscribe
    # no-op
  end

  def chimp_unsubscribe
    # these happen in callbacks
    # return true to not block
    true
  end
end

class Adopter
  def chimp_subscribe
    # these happen in callbacks
    # return true to not block
    true
  end

  def chimp_unsubscribe
    # these happen in callbacks
    # return true to not block
    true
  end

  def chimp_check
    # these happen in callbacks
    # return true to not block
    true
  end
end
