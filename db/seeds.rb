# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all

@attr = { name: "Admin User",
          email: "test3@test.com",
          password: "foobar99",
          region: 'NY',
          country: 'USA'
}

 user = User.create!(@attr)
 user.toggle!(:admin)

