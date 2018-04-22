FactoryBot.define do
  factory :dog do
    sequence(:tracking_id, ((Dog.pluck(:tracking_id) << 0).max.succ )) { |n| n }
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

    trait :primary_lab do
      primary_breed_id { create(:breed, name: 'Labrador Retriever').id }
      secondary_breed_id nil
    end

    trait :secondary_westie do
      primary_breed_id nil
      secondary_breed_id { create(:breed, name: 'West Highland Terrier').id }
    end

    Dog::STATUSES.each do |status|
      trait status.parameterize(separator: "_").to_sym do
        status status
      end
    end

    Dog::AGES.each do |age|
      trait age.to_sym do
        age age
      end
    end

    [ 'High Priority', 'Spay Neuter Needed' ].each do |flag|
      trait flag.downcase.parameterize(separator: "_").to_sym do
        add_attribute "is_#{flag.downcase.parameterize(separator: '_')}", true
      end
    end

    trait :medical_review_needed do
      needs_medical_review :false
    end

    trait :needs_foster do
      needs_foster true
    end

    trait :spay_neuter_needed do
       is_altered false
    end

    [ 'No Cats', 'No Dogs', 'No Kids' ].each do |flag|
      trait flag.downcase.parameterize(separator: "_").to_sym do
        add_attribute "#{flag.downcase.parameterize(separator: '_')}", true
      end
    end

  end
end
