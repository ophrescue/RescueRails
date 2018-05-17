# == Schema Information
#
# Table name: dogs
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  tracking_id             :integer
#  primary_breed_id        :integer
#  secondary_breed_id      :integer
#  status                  :string(255)
#  age                     :string(75)
#  size                    :string(75)
#  is_altered              :boolean
#  gender                  :string(6)
#  is_special_needs        :boolean
#  no_dogs                 :boolean
#  no_cats                 :boolean
#  no_kids                 :boolean
#  description             :text
#  foster_id               :integer
#  adoption_date           :date
#  is_uptodateonshots      :boolean          default(TRUE)
#  intake_dt               :date
#  available_on_dt         :date
#  has_medical_need        :boolean          default(FALSE)
#  is_high_priority        :boolean          default(FALSE)
#  needs_photos            :boolean          default(FALSE)
#  has_behavior_problem    :boolean          default(FALSE)
#  needs_foster            :boolean          default(FALSE)
#  petfinder_ad_url        :string(255)
#  adoptapet_ad_url        :string(255)
#  craigslist_ad_url       :string(255)
#  youtube_video_url       :string(255)
#  first_shots             :string(255)
#  second_shots            :string(255)
#  third_shots             :string(255)
#  rabies                  :string(255)
#  vac_4dx                 :string(255)
#  bordetella              :string(255)
#  microchip               :string(255)
#  original_name           :string(255)
#  fee                     :integer
#  coordinator_id          :integer
#  sponsored_by            :string(255)
#  shelter_id              :integer
#  medical_summary         :text
#  heartworm_preventative  :string
#  flea_tick_preventative  :string
#  medical_review_complete :boolean          default(FALSE)
#  behavior_summary        :text
#

require 'rails_helper'

describe Dog do
  describe '.update_adoption_date' do
    let(:dog) { create(:dog, :adoptable) }

    context 'status did not change' do
      it 'does not update the date' do
        old_date = dog.adoption_date
        dog.update_attribute(:name, "new_#{dog.name}")
        expect(dog.adoption_date).to eq(old_date)
      end
    end

    context 'status changed to completed' do
      it 'does not update the date' do
        old_date = dog.adoption_date
        dog.update_attribute(:status, 'completed')
        expect(dog.adoption_date).to eq(old_date)
      end
    end

    context 'status changed to adopted' do
      it 'updates the date' do
        dog.update_attribute(:status, 'adopted')
        expect(dog.adoption_date).to eq(Date.today())
      end
    end

    context 'status changed to value that is not complete or adopted' do
      it 'updates the date to nil' do
        dog.update_attribute(:status, 'adopted')
        expect(dog.adoption_date).to eq(Date.today)

        dog.update_attribute(:status, 'adoptable')
        expect(dog.adoption_date).to be_nil
      end
    end
  end

  describe 'matching_tracking_id scope' do
    let!(:good_dog){ create(:dog, tracking_id: 55) }
    let!(:bad_dog){ create(:dog, tracking_id: 77) }

    it 'result includes only matching tracking_id' do
      dogs = Dog.matching_tracking_id(55)
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
      expect(dogs).not_to include(bad_dog)
    end
  end

  describe 'matches_microchip scope' do
    let!(:good_dog){ create(:dog, microchip: 55) }
    let!(:bad_dog){ create(:dog, microchip: 77) }

    it 'result includes only matching tracking_id' do
      dogs = Dog.identity_matching_microchip(55)
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
      expect(dogs).not_to include(bad_dog)
    end
  end

  describe 'combined scopes with identity matches' do
    let!(:good_dog){ create(:dog, tracking_id: 55) }
    let!(:better_dog){ create(:dog, microchip: 66) }
    let!(:bad_dog){ create(:dog, tracking_id: 77) }
    let!(:badder_dog){ create(:dog, microchip: 88) }

    it 'result includes matches for either parameter' do
      dogs = Dog.matching_tracking_id(55).or(Dog.identity_matching_microchip(66))
      expect(dogs.length).to eq 2
      expect(dogs).to include(good_dog)
      expect(dogs).to include(better_dog)
    end

    it 'result includes matches for tracking_id when microchip field is nil' do
      dogs = Dog.matching_tracking_id(55).or(Dog.identity_matching_microchip(nil))
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
    end

    it 'result includes matches for microchip when tracking_id field is nil' do
      dogs = Dog.matching_tracking_id(nil).or(Dog.identity_matching_microchip(66))
      expect(dogs.length).to eq 1
      expect(dogs).to include(better_dog)
    end

    it 'result of combined scope matches either parameter' do
      dogs = Dog.identity_match_tracking_id_or_microchip(55)
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
      dogs = Dog.identity_match_tracking_id_or_microchip(66)
      expect(dogs.length).to eq 1
      expect(dogs).to include(better_dog)
    end
  end

  describe 'combined scopes with pattern matches' do
    let!(:good_dog){ create(:dog, name: 'Barney', microchip: 55) }
    let!(:better_dog){ create(:dog, microchip: 66) }
    let!(:bad_dog){ create(:dog, name: 'Bert', microchip: 77) }
    let!(:badder_dog){ create(:dog, microchip: 88) }

    it 'result includes matches for either parameter' do
      dogs = Dog.pattern_matching_microchip('66').or(Dog.pattern_matching_name('bar%'))
      expect(dogs.length).to eq 2
      expect(dogs).to include(good_dog)
      expect(dogs).to include(better_dog)
    end

    it 'result includes matches for name when microchip field is nil' do
      dogs = Dog.pattern_matching_microchip(nil).or(Dog.pattern_matching_name('bar%'))
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
    end

    it 'result includes matches for microchip when name field is nil' do
      dogs = Dog.pattern_matching_microchip('66').or(Dog.pattern_matching_name(nil))
      expect(dogs.length).to eq 1
      expect(dogs).to include(better_dog)
    end

    it 'result of combined scope pattern matches either parameter' do
      dogs = Dog.pattern_match_microchip_or_name('66')
      expect(dogs.length).to eq 1
      expect(dogs).to include(better_dog)
      dogs = Dog.pattern_match_microchip_or_name('bar%')
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
    end
  end
end
