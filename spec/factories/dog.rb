FactoryBot.define do
  factory :dog do
    sequence(:tracking_id) { |n| n }
    name { 
      until(nn = Faker::Dog.name; !Dog.pluck(:name).include?(nn))
      end
      nn
    }
    status {  Dog::STATUSES.sample }
    sequence(:microchip) { |n| "MC-#{n}" }
    age { Dog::AGES.sample }
    size { Dog::SIZES.sample }
    gender { Dog::GENDERS.sample }
    medical_review_complete { [true,false].sample }
    has_medical_need { [true, false].sample }
    is_high_priority { [true, false].sample }
    needs_photos { [true, false].sample }
    has_behavior_problem { [true, false].sample }
    needs_foster { [true, false].sample }
    is_altered { [true, false].sample }
    intake_dt { Date.today.advance(:days => -rand(365)) }
    primary_breed_id { Breed.pluck(:id).sample }
    secondary_breed_id { Breed.pluck(:id).sample }

    after(:create) do |dog|
      create(:comment, :commentable_type => 'Dog', :commentable_id => dog.id, :content => Faker::Lorem.sentence )
    end

    factory :dog_with_photo_and_attachment do
      after(:build) do |dog|
        build(:attachment, attachable: dog)
        build(:photo, dog: dog)
      end
    end

    trait :adoptable do
      status 'adoptable'
    end

    trait :completed do
      status 'completed'
    end
  end
end
