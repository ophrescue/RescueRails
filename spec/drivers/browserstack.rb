require 'browserstack/local'
require 'rescue_rails/browser_stack'

Capybara.register_driver :browserstack do |app|
  include RescueRails::BrowserStack
  @bs_local = start_bs_local

  Capybara::Selenium::Driver.new(app,
    :browser => :remote,
    :url => url,
    :desired_capabilities => capabilities
  )
end
