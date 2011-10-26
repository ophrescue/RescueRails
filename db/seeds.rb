# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create default admin user.

User.destroy_all

@attr = { :name => "Admin User",
          :email => "test@test.com",
          :password => "foobar",
          :password_confirmation => "foobar",
          :admin => true
}

 User.create!(@attr)


 # Load list of breeds to breed table

 Breed.destroy_all
 open("db/dog_breeds.txt") do |breeds|
 	breeds.read.each_line do |breed|
 		breed = breed.chomp
 		Breed.create!(:name => breed)
 	end
 end