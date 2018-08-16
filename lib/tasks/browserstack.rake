task :bs_test => :environment do
  [{browser: "Chrome/65.0",  os: "Windows/10"},
   {browser: "Firefox/58.0", os: "Windows/10"},
   {browser: "Edge/17.0",    os: "Windows/10"},
   {browser: "Safari/11.0",  os: "OS X/High Sierra"},
   {browser: "Chrome/68.0",  os: "OS X/High Sierra"}].each do |config|
    logfile = Rails.root.join('log', "browserstack_#{config.values.join('_').gsub(/\//,'_').gsub(/\s/,'_')}.log")
    FileUtils.rm_f(logfile)
    `:> log/test.log`
    `OS="#{config[:os]}" BROWSER=#{config[:browser]} rspec spec/features/add_dog_spec.rb:238`
    FileUtils.mv Rails.root.join('log', 'test.log'), logfile
  end
end
