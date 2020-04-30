# RescueRails

[![Code Climate](https://codeclimate.com/github/ophrescue/RescueRails.png)](https://codeclimate.com/github/ophrescue/RescueRails) [![Build Status](https://travis-ci.org/ophrescue/RescueRails.svg?branch=master)](https://travis-ci.org/ophrescue/RescueRails) [![Coverage Status](https://coveralls.io/repos/github/ophrescue/RescueRails/badge.svg?branch=master)](https://coveralls.io/github/ophrescue/RescueRails?branch=master)

Rails 5.2.x
Ruby 2.6.6
Postgresql 9.6.x

## About
RescueRails is the public facing website for Operation Paws for Homes, as well as the private system used by the rescue for managing dogs, adopters and staff.


## Developer Notes
### Setup in dev

    git clone git@github.com:ophrescue/RescueRails.git
    cd RescueRails
    bundle install

Create database.yml file, and use postgres

    rake db:setup
    rake db:seed

You're also going to need to setup the auto incrementor in postgresql on the dogs.tracking_id column.  Run these commands for both your development and test databases:

```
psql                                            //launch Postgresql command line
\list                                          //to get a list of your databases if you don't remember
\connect TheNameOfYourDatabase
CREATE SEQUENCE tracking_id_seq START 1;
CREATE SEQUENCE cat_tracking_id_seq START 1;
\q                                              //quit and return to command prompt.
```

Fire up the app and see what happens.  App is setup to run SSL always, might want to use POW as your webserver in dev.

See `db/seeds.rb` for default admin login info

### Running Tests
#### Default test configuration
Tests are run by default via Headless Chrome, which will require Google Chrome and ChromeDriver.
```
brew install chromedriver
```
then run tests with:
```
rspec spec
```
or
```
rake spec
```
or even just
```
rake
```
#### Firefox testing
To run tests with headless Firefox, you will need geckodriver
```
brew install geckodriver
```
and then run tests with:
```
BROWSER=firefox_headless rspec spec # environment variable switch in rails_helper.rb
```
To facilitate debugging, you can run Firefox in the non-headless mode with:
```
BROWSER=firefox_local rspec spec
```
#### Testing on BrowserStack
To test on BrowserStack's Automate service, the account credentials must be set as environment variables:
```
export BROWSERSTACK_USER=<your browserstack username>
export BROWSERSTACK_KEY=<your browserstack key>
```
Then the BrowserStack OS and browser configuration is established for a test suite with environment variables according to this pattern:
```
BROWSER="browser name/browser version" OS="os name/os version" rspec spec/features
```
for example:
```
BROWSER="Edge/17.0" OS="Windows/10" rspec spec/features
```
Since Internet Explorer and Edge are normally associated with Windows, and Safari is normally associated with OS X, these browsers are inferred if missing and the following invocations may be used:
```
BROWSER="Edge/17.0" rspec spec/features
BROWSER="Internet Explorer/11.0" rspec spec/features
BROWSER="Safari/11.1" rspec spec/features
```
The progress of the test can be monitored on the [Automate dashboard](https://automate.browserstack.com).
The full set of browser and OS configuration options are found [here](https://www.browserstack.com/automate/capabilities).
#### Testing with Internet Explorer
Internet explorer is not able to be controlled through its api to upload files. Therefore all tests that involve uploading files in spec/features are tagged with:
```
exclude_ie: true
```
And the test invocation for testing with IE on BrowserStack should be:
```
BROWSER="Internet Explorer/11.0" rspec spec/features --tag ~exclude_ie:true
```
The ~ here indicates negation, meaning run all tests in spec/features _except_ those tagged with `exclude_ie=true`.
#### BrowserStack Troubleshooting
During development this error may be encountered:
```
Either another browserstack local client is running on your machine or some server is listening on port 45691
```
This is typically due to premature termination of a test run, so that the browserstack_local utility was not properly terminated.
The recovery is to find the process that is bound to port 45691:
```
> netstat -vanp tcp | grep 45691
> tcp4       0      0  *.45691                *.*                    LISTEN      131072 131072  54981      0
```
Then killing the process indicated (in this case it's 54981):
```
kill -9 54981
```
#### Running against multiple browsers
A rake task is included to test against multiple browsers:
```
rake rescue_rails:test_suite
```
### File Attachment Storage
Storage for photos (photo.rb) and attachments (attachment.rb) is managed by the Paperclip gem and is on AWS S3 in production and staging environments, and under Rails root for development and testing environments.

The storage paths are configured for production, staging, and test environments in the environments/*.rb files.

For the development environment, the Paperclip default file system structure is followed, so no configuration is necessary. The file path for photos is public/system/photos/photos/nnn/nnn/nnn/size/*, and for attachments: public/system/attachments/attachments/nnn/nnn/nnn/original/*, where nnn etc is a 9 digits of the object id split into 3x 3-digit segments.

For the test environment, the storage is ephemeral and files are destroyed at the end of each test suite run. To facilitate this cleanup, files are stored in public/system/test/**/* file hierarchy, configured in the PAPERCLIP_STORAGE_PATH constant.

For the production and staging environments, the path is formed by the concatenation of AWS ENV variables, and the path strings stored in PAPERCLIP_STORAGE_PATH constant.

## Contributing

If you're very new to web development or to Ruby on Rails, you'll have a lot to learn before you get started.  I recommend [learnenough.com](https://www.learnenough.com/) and [railstutorial.org](https://www.railstutorial.org/) as imporant first steps to complete.

Otherwise, Pull Requests are always welcome, see our [project](https://github.com/orgs/ophrescue/projects/1) for backlog items.  Please include some rspec tests to verify your work.  If you'd like to be a regular contributor and work on some of the more involved items in the backlog, please submit a volunteer application at https://ophrescue.org/volunteer.  Thanks!

## Browser Support
Supported browsers and platforms are those specified for the version of Boostrap incorporated. See the Bootstrap documentation: getting-started/browsers-devices for the appropriate version.

## Licensing
* Source code written for this project has been licensed under the Apache 2.0 license
* 3rd party libraries that may appear are licensed as identified.
* Logos and images remain copyright of their respective owners.
* Documents appearing in public\docs remain property of Operation Paws for Homes, Inc. and may not be reused without written permission.
