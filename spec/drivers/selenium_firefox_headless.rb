Capybara.register_driver :selenium_firefox_headless do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('-headless')
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :options => options)
end

Capybara::Screenshot.register_driver(:selenium_firefox_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end
