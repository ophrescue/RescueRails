# RescueRails 

[![Code Climate](https://codeclimate.com/github/ophrescue/RescueRails.png)](https://codeclimate.com/github/ophrescue/RescueRails)

[![Gemnasium](https://gemnasium.com/ophrescue/RescueRails.png)](https://gemnasium.com/ophrescue/RescueRails)

[![Build Status](https://travis-ci.org/ophrescue/RescueRails.svg?branch=travis)](https://travis-ci.org/ophrescue/RescueRails)

Rails 3.2.x
Ruby 2.1.1
Postgresql 9.3.x

### About
RescueRails is the public facing website for Operation Paws for Homes, as well as the private system used by the rescue for managing dogs, adopters and staff.  The project is open on Githup for the benefit of our volunteer development team.  



### Setup in dev

    git clone git@github.com:ophrescue/RescueRails.git
    cd RescueRails
    bundle install

Create database.yml file, and use postgres

    rake db:setup
    rake db:seed
    
You're also going to need to setup an auto incrementor in postgresql on the dogs.tracking_id column.  This isn't in the schema. :(

Fire up the app and see what happens.  App is setup to run SSL always, might want to use POW as your webserver in dev.

See `db/seeds.rb` for default admin login info


There is also a watir script in `/spec/watir` that will execute a test of the Adoption application.  You'll need to configure watir on your machine.



