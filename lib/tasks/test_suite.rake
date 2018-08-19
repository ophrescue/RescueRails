namespace :rescue_rails do
  desc "run the entire test suite with the default browser, then run features specs with firefox headless"
  task :test_suite do
    system 'rspec spec/'
    system 'BROWSER=firefox_headless rspec spec/features'
  end
end
