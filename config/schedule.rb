# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever

set :output, 'log/whenever.log'

every :day, at: '2:30am' do
  rake "petfinder_sync:export_records"
  rake "petfinder_sync:upload"
end