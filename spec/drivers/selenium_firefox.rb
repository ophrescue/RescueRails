Capybara.register_driver :selenium_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :options => options)
end

Capybara::Screenshot.register_driver(:selenium_firefox) do |driver, path|
  driver.browser.save_screenshot(path)
end
