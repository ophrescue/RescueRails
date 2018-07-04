require 'factory_bot'

namespace :rescue_rails do
  desc "populate database tables"
  task populate_all: [:populate_users, :populate_breeds, :populate_adopters, :populate_dogs, :populate_events] do
    tables = ["users", "breeds", "adopters", "dogs", "fosters", "adoptions", "events"]
    tables.each do |table|
      Rake::Task["rescue_rails:populate_#{table}"].invoke
    end
  end

  desc "populate events"
  task populate_events: :environment do
    Event.destroy_all
    10.times do
      FactoryBot.create(:event)
    end
  end

  desc "populate breeds"
  task populate_breeds: :environment do
    Breed.destroy_all
    100.times do
      FactoryBot.create(:breed)
    end
  end

  desc "populate adopters"
  task populate_adopters: :environment do
    Adopter.destroy_all
    20.times do
      FactoryBot.create(:adopter_with_app)
    end
  end

  desc "populate dogs"
  task populate_dogs: :environment do
    Dog.destroy_all
    120.times do
      FactoryBot.create(:dog)
    end
  end

  desc "populate users"
  task populate_users: :environment do
    User.destroy_all
    FactoryBot.create(:user, :admin, :with_known_authentication_parameters)
    25.times do
      FactoryBot.create(:user)
    end
  end

  desc "populate adoptions"
  task populate_adoptions: :environment do
    20.times do
      # creates adoption relationships between existing adopters and dogs
      # instead of creating new adopters and dogs
      FactoryBot.create(:adoption_from_existing)
    end
  end

  desc "create fosters"
  task populate_fosters: :environment do
    foster_user_ids = User.pluck(:id).sample(15).shuffle
    foster_dog_ids = Dog.pluck(:id).shuffle
    foster_user_ids.each do |id|
      (1..4).to_a.sample.times do
        dog_id = foster_dog_ids.sample
        foster_dog_ids.delete(dog_id)
        Dog.find(dog_id).update_attribute(:foster_id, id)
      end
    end
  end

  desc "create photos, with links to actual pics on AWS, taken from production data"
  task populate_photos: :environment do
    Photo.destroy_all
    json = JSON.load(File.read(Rails.root.join('lib','data','dog_photos.json')))
    all_dog_ids = Dog.pluck(:id)
    map = {} # {photo.dog_id => dog.id, ...}
    json.each_with_index do |json_attrs,i|
      photo = Photo.new.from_json(json_attrs)
      if map[photo.dog_id]
        photo.dog_id = map[photo.dog_id]
      else
        new_map_val = map.values.last&.succ || all_dog_ids[0]
        map.merge!({photo.dog_id => new_map_val })
        photo.dog_id = new_map_val
      end
      photo.save
    end
  end

end
