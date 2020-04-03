FactoryBot.define do
  factory :dog do
    tracking_id { Dog.next_tracking_id }
    name {
      until(nn = Faker::Creature::Dog.name; !Dog.pluck(:name).include?(nn))
      end
      # it's a workaround for TravisCI sorting weirdness.
      # It doesn't handle spaces inside names as expected
      # (expected means ' '< 'x')
      nn.gsub(/(\W|\s)/,'').titlecase
    }
    status {  Dog::STATUSES.sample }
    hidden { false }
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
    vac_4dx { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    bordetella { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    heartworm_preventative { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    flea_tick_preventative { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    dewormer { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    toltrazuril { [nil, Date.today.advance(days: -rand(365)).to_s].sample }

    trait :with_comment do
      after(:create) do |dog|
        create(:comment, :commentable_type => 'Dog', :commentable_id => dog.id, :content => Faker::Lorem.sentence )
      end
    end

    factory :dog_with_photo_and_attachment do
      after(:build) do |dog|
        build(:attachment, attachable: dog)
        build(:photo, animal_type: 'Dog', animal_id: dog.id)
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
      after(:create) do |dog|
        `mkdir -p #{Rails.root.join("public","system","test","photos")}`
        3.times do |i|
          photo = FactoryBot.create(:photo, animal_type: 'Dog', animal_id: dog.id, is_private: false, position: i+1 )
          ["medium", "original"].each do |style|
            data = "photos/photos/#{photo.id}/#{style}/"
            hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, Photo::HASH_SECRET, data)
            filepath = "public/system/test/photos/#{hash}.jpeg"
            image_source = Rails.root.join('spec','fixtures','photo','animal_pic.jpg').to_s
            `cp #{image_source} #{Rails.root.join(filepath)}`
          end
        end
      end
    end

    trait :active_dog do
      status { Dog::ACTIVE_STATUSES.sample }
    end

    trait :primary_lab do
      primary_breed_id { create(:breed, name: 'Labrador Retriever').id }
      secondary_breed_id { nil }
    end

    trait :primary_and_secondary_terrier do
      primary_breed_id { create(:breed, name: 'Cairn Terrier').id }
      secondary_breed_id { create(:breed, name: 'Yorkshire Terrier').id }
    end

    trait :secondary_golden do
      primary_breed_id { create(:breed, name: 'Golden Retriever').id }
      secondary_breed_id { nil }
    end

    trait :secondary_westie do
      primary_breed_id { nil }
      secondary_breed_id { create(:breed, name: 'West Highland Terrier').id }
    end

    Dog::STATUSES.each do |status|
      trait status.parameterize(separator: "_").to_sym do
        status { status }
      end
    end

    Dog::AGES.each do |age|
      trait age.to_sym do
        age { age }
      end
    end

    [ 'High Priority', 'Spay Neuter Needed' ].each do |flag|
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

    factory :terrier do
      primary_breed_id { Breed.find_or_create_by(name: 'terrier').id }
    end
  end
end
