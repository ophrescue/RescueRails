Capybara.register_driver :local_ie do |app|
  url = "http://192.168.1.7:4444/wd/hub"
  capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer
  capabilities.version = "11"

  Capybara::Selenium::Driver.new(app,
    :browser => :remote,
    :url => url,
    :desired_capabilities => capabilities)
end
