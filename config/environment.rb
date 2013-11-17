# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RescueRails::Application.initialize!

if Rails.env.development?
#  Rails.logger = Le.new('8934d33d-a639-4ede-9442-1046d8a35cd2', debug: true)
else
  Rails.logger = Le.new('8934d33d-a639-4ede-9442-1046d8a35cd2')
end