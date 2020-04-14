# == Schema Information
#
# Table name: cats
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  original_name           :string
#  tracking_id             :integer
#  primary_breed_id        :integer
#  secondary_breed_id      :integer
#  status                  :string
#  age                     :string(75)
#  size                    :string(75)
#  is_altered              :boolean
#  gender                  :string(6)
#  declawed                :boolean
#  litter_box_trained      :boolean
#  coat_length             :string
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
#  microchip               :string
#  fee                     :integer
#  coordinator_id          :integer
#  sponsored_by            :string
#  shelter_id              :integer
#  medical_summary         :text
#  behavior_summary        :text
#  medical_review_complete :boolean          default(FALSE)
#  first_shots             :string
#  second_shots            :string
#  third_shots             :string
#  rabies                  :string
#  felv_fiv_test           :string
#  flea_tick_preventative  :string
#  dewormer                :string
#  coccidia_treatment      :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#


require 'rails_helper'

describe Cat do
  describe '.update_adoption_date' do
    # tests for the update_adoption_date callback simply document the behaviour found in the code
    # without understanding the intent or validating correctness
    let(:cat) { create(:cat, :adoptable) }

    context 'status did not change' do
      it 'does not update the date if none is provided' do
        old_date = cat.adoption_date
        cat.update_attribute(:name, "new_#{cat.name}")
        expect(cat.adoption_date).to eq(old_date)
      end

      it 'updates the date to the value provided ' do
        cat.update_attribute(:adoption_date, '2024-8-19')
        expect(cat.adoption_date).to eq(Date.new(2024,8,19))
      end
    end

    context 'status changed to completed' do
      it 'does not update the date' do
        old_date = cat.adoption_date
        cat.update_attribute(:status, 'completed')
        expect(cat.adoption_date).to eq(old_date)
      end

      it 'updates the adoption date if one is provided by the user' do
        cat.update_attributes(status: 'completed', adoption_date: Date.new(2000,1,1))
        expect(cat.adoption_date).to eq(Date.new(2000,1,1))
      end
    end

    context 'status changed to adopted' do
      it 'updates the date' do
        cat.update_attribute(:status, 'adopted')
        expect(cat.adoption_date).to eq(Date.today())
      end
    end

    context 'status changed to value that is not complete or adopted' do
      it 'updates the date to nil' do
        cat.update_attribute(:status, 'adopted')
        expect(cat.adoption_date).to eq(Date.today)

        cat.update_attribute(:status, 'adoptable')
        expect(cat.adoption_date).to be_nil
      end
    end
  end

  describe '.needs_foster' do
    let(:cat) { create(:cat, :adoptable, needs_foster: true) }

    context 'status changed to adopted' do
      it 'sets needs_foster to FALSE' do
        cat.update_attribute(:status, 'adopted')
        expect(cat.needs_foster).to eq(false)
      end
    end

    context 'status changed to completed' do
      it 'sets needs_foster to FALSE' do
        cat.update_attribute(:status, 'completed')
        expect(cat.needs_foster).to eq(false)
      end
    end

    context 'status changed to trial adoption' do
      it 'sets needs_foster to FALSE' do
        cat.update_attribute(:status, 'trial adoption')
        expect(cat.needs_foster).to eq(false)
      end
    end

    context 'status changed to on hold' do
      it 'needs_foster is not changed' do
        cat.update_attribute(:status, 'on hold')
        expect(cat.needs_foster).to eq(true)
      end
    end
  end

  describe 'matching_tracking_id scope' do
    let!(:good_cat){ create(:cat, tracking_id: 55) }
    let!(:bad_cat){ create(:cat, tracking_id: 77) }

    it 'result includes only matching tracking_id' do
      cats = Cat.search(['55','tracking_id'])
      expect(cats.length).to eq 1
      expect(cats).to include(good_cat)
      expect(cats).not_to include(bad_cat)
    end
  end

  describe 'matches_microchip scope' do
    let!(:good_cat){ create(:cat, microchip: 55) }
    let!(:bad_cat){ create(:cat, microchip: 77) }

    it 'result includes only matching tracking_id' do
      cats = Cat.search(['55','microchip'])
      expect(cats.length).to eq 1
      expect(cats).to include(good_cat)
      expect(cats).not_to include(bad_cat)
    end
  end
end
