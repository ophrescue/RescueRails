# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if User.first.nil?
  @attr = { name: "Admin User",
            email: "test3@test.com",
            password: "foobar99",
            password_confirmation: "foobar99",
            region: 'NY',
            country: 'USA'}

  user = User.create!(@attr)
  user.toggle!(:admin)
end

if Breed.first.nil?
  open("db/dog_breeds.txt") do |breeds|
    breeds.read.each_line do |breed|
      breed = breed.chomp
      Breed.create!(name: breed)
    end
  end
end

if CatBreed.first.nil?
  open("db/cat_breeds.txt") do |breeds|
    breeds.read.each_line do |breed|
      breed = breed.chomp
      CatBreed.create!(name: breed)
    end
  end
end
