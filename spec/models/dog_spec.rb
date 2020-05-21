# == Schema Information
#
# Table name: dogs
#
#  id                      :integer          not null, primary key
#  name                    :string
#  created_at              :datetime
#  updated_at              :datetime
#  tracking_id             :integer
#  primary_breed_id        :integer
#  secondary_breed_id      :integer
#  status                  :string
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
#  petfinder_ad_url        :string
#  craigslist_ad_url       :string
#  youtube_video_url       :string
#  first_shots             :string
#  second_shots            :string
#  third_shots             :string
#  rabies                  :string
#  vac_4dx                 :string
#  bordetella              :string
#  microchip               :string
#  original_name           :string
#  fee                     :integer
#  coordinator_id          :integer
#  sponsored_by            :string
#  shelter_id              :integer
#  medical_summary         :text
#  heartworm_preventative  :string
#  flea_tick_preventative  :string
#  medical_review_complete :boolean          default(FALSE)
#  behavior_summary        :text
#  dewormer                :string
#  toltrazuril             :string
#  hidden                  :boolean          default(FALSE), not null
#  wait_list               :text
#  no_urban_setting        :boolean          default(FALSE), not null
#  home_check_required     :boolean          default(FALSE), not null
#

require 'rails_helper'

describe Dog do
  describe '.update_adoption_date' do
    # tests for the update_adoption_date callback simply document the behaviour found in the code
    # without understanding the intent or validating correctness
    let(:dog) { create(:dog, :adoptable) }

    context 'status did not change' do
      it 'does not update the date if none is provided' do
        old_date = dog.adoption_date
        dog.update_attribute(:name, "new_#{dog.name}")
        expect(dog.adoption_date).to eq(old_date)
      end

      it 'updates the date to the value provided ' do
        dog.update_attribute(:adoption_date, '2024-8-19')
        expect(dog.adoption_date).to eq(Date.new(2024,8,19))
      end
    end

    context 'status changed to completed' do
      it 'does not update the date' do
        old_date = dog.adoption_date
        dog.update_attribute(:status, 'completed')
        expect(dog.adoption_date).to eq(old_date)
      end

      it 'updates the adoption date if one is provided by the user' do
        dog.update_attributes(status: 'completed', adoption_date: Date.new(2000,1,1))
        expect(dog.adoption_date).to eq(Date.new(2000,1,1))
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

  describe '.needs_foster' do
    let(:dog) { create(:dog, :adoptable, needs_foster: true) }

    context 'status changed to adopted' do
      it 'sets needs_foster to FALSE' do
        dog.update_attribute(:status, 'adopted')
        expect(dog.needs_foster).to eq(false)
      end
    end

    context 'status changed to completed' do
      it 'sets needs_foster to FALSE' do
        dog.update_attribute(:status, 'completed')
        expect(dog.needs_foster).to eq(false)
      end
    end

    context 'status changed to trial adoption' do
      it 'sets needs_foster to FALSE' do
        dog.update_attribute(:status, 'trial adoption')
        expect(dog.needs_foster).to eq(false)
      end
    end

    context 'status changed to on hold' do
      it 'needs_foster is not changed' do
        dog.update_attribute(:status, 'on hold')
        expect(dog.needs_foster).to eq(true)
      end
    end

  end

  describe 'matching_tracking_id scope' do
    let!(:good_dog){ create(:dog, tracking_id: 55) }
    let!(:bad_dog){ create(:dog, tracking_id: 77) }

    it 'result includes only matching tracking_id' do
      dogs = Dog.search(['55','tracking_id'])
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
      expect(dogs).not_to include(bad_dog)
    end
  end

  describe 'matches_microchip scope' do
    let!(:good_dog){ create(:dog, microchip: 55) }
    let!(:bad_dog){ create(:dog, microchip: 77) }

    it 'result includes only matching tracking_id' do
      dogs = Dog.search(['55','microchip'])
      expect(dogs.length).to eq 1
      expect(dogs).to include(good_dog)
      expect(dogs).not_to include(bad_dog)
    end
  end

end
