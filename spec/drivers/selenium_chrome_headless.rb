Capybara.register_driver :selenium_chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1366,2000] }
  )
  Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
end
