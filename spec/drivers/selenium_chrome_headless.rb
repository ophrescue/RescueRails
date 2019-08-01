Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless disable-dev-shm-usage no-sandbox disable-gpu window-size=1366,2000],
    log_level: :error
  )
  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end
