FactoryBot.define do
    factory :cat do
      tracking_id { Cat.next_tracking_id }
      name {
        until(nn = Faker::Creature::Cat.name; !Cat.pluck(:name).include?(nn))
        end
        # it's a workaround for TravisCI sorting weirdness.
        # It doesn't handle spaces inside names as expected
        # (expected means ' '< 'x')
        nn.gsub(/(\W|\s)/,'').titlecase
      }
      status {  Cat::STATUSES.sample }
      sequence(:microchip) { |n| "MC-#{n}" }
      age { Cat::AGES.sample }
      size { Cat::SIZES.sample }
      gender { Cat::GENDERS.sample }
      declawed { [true, false].sample }
      litter_box_trained { [true, false].sample }
      coat_length { Cat::COAT_LENGTH.sample }
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
      is_uptodateonshots { [true, false].sample }
      is_special_needs        { [true, false].sample }
      no_dogs                 { [true, false].sample }
      no_cats                 { [true, false].sample }
      no_kids                 { [true, false].sample }
      description { Faker::Lorem.paragraphs(number: 3, supplemental: true).join("\n\n") }
      medical_summary { Faker::Lorem.paragraph }
      behavior_summary { Faker::Lorem.paragraph }
      craigslist_ad_url { [Faker::Internet.url, nil].sample }
      first_shots { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      second_shots { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      third_shots { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      rabies { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      felv_fiv_test { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      flea_tick_preventative { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      dewormer { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
      coccidia_treatment { [nil, Date.today.advance(days: -rand(365)).to_s].sample }

      trait :with_comment do
        after(:create) do |cat|
          create(:comment, :commentable_type => 'Cat', :commentable_id => cat.id, :content => Faker::Lorem.sentence )
        end
      end

      factory :cat_with_photo_and_attachment do
        after(:build) do |cat|
          build(:attachment, attachable: cat)
          build(:photo, animal_type: 'Cat', animal_id: cat.id)
        end
      end

      trait :no_flags do
        [ :medical_review_complete, :has_medical_need, :is_special_needs, :is_altered, :is_high_priority, :needs_photos,
          :has_behavior_problem, :needs_foster, :no_dogs, :no_cats, :no_kids ].each do |flag|
          add_attribute(flag) { nil }
        end
      end

      # file paths here are for test environment, they are not appropriate
      # for development environment
      trait :with_photos do
        after(:create) do |cat|
          `mkdir -p #{Rails.root.join("public","system","test","photos")}`
          3.times do |i|
            photo = FactoryBot.create(:photo, cat: cat, is_private: false, position: i+1 )
            ["medium", "original"].each do |style|
              data = "photos/photos/#{photo.id}/#{style}/"
              hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, Photo::HASH_SECRET, data)
              filepath = "public/system/test/photos/#{hash}.jpeg"
              image_source = Rails.root.join('spec','fixtures','photo','cat_pic.jpg').to_s
              `cp #{image_source} #{Rails.root.join(filepath)}`
            end
          end
        end
      end

      trait :active_cat do
        status { Cat::ACTIVE_STATUSES.sample }
      end

      trait :primary_tabby do
        primary_breed_id { create(:breed, name: 'Tabby').id }
        secondary_breed_id { nil }
      end

      trait :primary_and_secondary_hair do
        primary_breed_id { create(:breed, name: 'American Shorthair').id }
        secondary_breed_id { create(:breed, name: 'American Wirehair').id }
      end

      trait :secondary_tabby do
        primary_breed_id { nil }
        secondary_breed_id { create(:breed, name: 'Tabby').id  }
      end

      trait :secondary_persian do
        primary_breed_id { nil }
        secondary_breed_id { create(:breed, name: 'Persian').id }
      end

      Cat::STATUSES.each do |status|
        trait status.parameterize(separator: "_").to_sym do
          status { status }
        end
      end

      Cat::AGES.each do |age|
        trait age.to_sym do
          age { age }
        end
      end

      ['High Priority', 'Spay Neuter Needed' ].each do |flag|
        trait flag.downcase.parameterize(separator: "_").to_sym do
          add_attribute("is_#{flag.downcase.parameterize(separator: '_')}") { true }
        end
      end

      trait :medical_review_needed do
        needs_medical_review { :false }
      end

      trait :needs_foster do
        needs_foster { true }
      end

      trait :spay_neuter_needed do
         is_altered { false }
      end

      [ 'No Cats', 'No Dogs', 'No Kids' ].each do |flag|
        trait flag.downcase.parameterize(separator: "_").to_sym do
          add_attribute("#{flag.downcase.parameterize(separator: '_')}") { true }
        end
      end

      factory :tabby do
        primary_breed_id { CatBreed.find_or_create_by(name: 'tabby').id }
      end
    end
  end
