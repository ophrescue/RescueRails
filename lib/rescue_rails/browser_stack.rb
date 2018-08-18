module RescueRails::BrowserStack
  def capabilities
    raise ArgumentError, "browser must be specified" unless ENV["BROWSER"]
    _browser, _browser_version = parse_config(ENV["BROWSER"])
    raise ArgumentError, "format must be browser/version" unless [_browser, _browser_version].all?
    _os, _os_version = get_os(ENV, _browser)
    opts = {os: _os, os_version: _os_version, browser: _browser, browser_version: _browser_version}
    default_capabilities.merge opts
  end

  def default_capabilities
  # ref https://www.browserstack.com/automate/capabilities
  { "project"=>"RescueRails",
    "build"=>"rspec-capybara-browserstack",
    "browserstack.debug"=>true,
    "window.size" => [1200, 800],
    "browserstack.local"=>true,
    "browserstack.networkLogs"=>true,
    "browserstack.selenium_version" => "3.11.0"}
  end

  def url
    "http://#{user}:#{key}@#{server}/wd/hub"
  end

  def start_bs_local
    bs_local = BrowserStack::Local.new
    bs_local.start({"key" => key})
    bs_local
  end

  private
  def get_os(env, browser)
    env["OS"] ? parse_config(env["OS"]) : infer_os(browser)
  end

  def infer_os(browser)
    case browser
    when /ie/i
      ["Windows","10"]
    when /explorer/i
      ["Windows","10"]
    when /edge/i
      ["Windows","10"]
    when /safari/i
      ["OS X", "High Sierra"]
    when /firefox/i
      raise ArgumentError, "OS must be specified for Firefox"
    when /chrome/i
      raise ArgumentError, "OS must be specified for Chrome"
    end
  end

  def parse_config(string)
    string.split("/").map(&:strip)
  end

  def server
    "hub-cloud.browserstack.com"
  end

  def user
    user = ENV['browserstack_user']
    raise "browserstack_user environment variable not configured" if user.nil?
    user
  end

  def key
    key = ENV['browserstack_key']
    raise "browserstack_key environment variable not configured" if key.nil?
    key
  end

end
