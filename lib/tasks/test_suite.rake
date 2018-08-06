namespace :rescue_rails do
  task :test_suite do
    system 'rspec spec/'
    system 'BROWSER=firefox_headless rspec spec/features'
  end
end
