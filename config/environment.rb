# Load the Rails application.
require_relative 'application'
Dir.glob(Rails.root.join('lib','local_extensions','*')).each{|file| require file }

# Initialize the Rails application.
Rails.application.initialize!
