Capybara.register_driver :selenium_chrome_headless do |app|
  Webdrivers::Chromedriver.version = '2.40'
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1366,2000] }
  )
  Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
end
