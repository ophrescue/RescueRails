# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'factory_bot'
FactoryBot.find_definitions

User.destroy_all
Breed.destroy_all
Adopter.destroy_all
Dog.destroy_all

#@attr = { name: "Admin User",
          #email: "test3@test.com",
          #password: "foobar99",
          #password_confirmation: "foobar99",
          #region: 'NY',
          #country: 'USA'
#}

 #user = User.create!(@attr)
 #user.toggle!(:admin)

FactoryBot.create(:user, :admin, :with_known_authentication_parameters)

100.times do
  FactoryBot.create(:breed)
end

60.times do
  FactoryBot.create(:dog)
end

20.times do
  FactoryBot.create(:adopter_with_app)
end

20.times do
  # creates adoption relationships between existing adopters and dogs
  # instead of creating new adopters and dogs
  FactoryBot.create(:adoption_from_existing)
end

25.times do
  FactoryBot.create(:user)
end

foster_user_ids = User.pluck(:id).sample(15).shuffle
foster_dog_ids = Dog.pluck(:id).shuffle
puts "fosterable dog count #{foster_dog_ids.length}"
foster_user_ids.each do |id|
  (1..4).to_a.sample.times do
    dog_id = foster_dog_ids.sample
    puts "dog tracking_id #{Dog.find(dog_id).tracking_id}"
    foster_dog_ids.delete(dog_id)
    puts "fosterable dog count #{foster_dog_ids.length}"
    Dog.find(dog_id).update_attribute(:foster_id, id)
  end
end
