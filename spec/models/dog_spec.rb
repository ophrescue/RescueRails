# == Schema Information
#
# Table name: dogs
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  tracking_id            :integer
#  primary_breed_id       :integer
#  secondary_breed_id     :integer
#  status                 :string(255)
#  age                    :string(75)
#  size                   :string(75)
#  is_altered             :boolean
#  gender                 :string(6)
#  is_special_needs       :boolean
#  no_dogs                :boolean
#  no_cats                :boolean
#  no_kids                :boolean
#  description            :text
#  foster_id              :integer
#  adoption_date          :date
#  is_uptodateonshots     :boolean          default(TRUE)
#  intake_dt              :date
#  available_on_dt        :date
#  has_medical_need       :boolean          default(FALSE)
#  is_high_priority       :boolean          default(FALSE)
#  needs_photos           :boolean          default(FALSE)
#  has_behavior_problem   :boolean          default(FALSE)
#  needs_foster           :boolean          default(FALSE)
#  petfinder_ad_url       :string(255)
#  adoptapet_ad_url       :string(255)
#  craigslist_ad_url      :string(255)
#  youtube_video_url      :string(255)
#  first_shots            :string(255)
#  second_shots           :string(255)
#  third_shots            :string(255)
#  rabies                 :string(255)
#  vac_4dx                :string(255)
#  bordetella             :string(255)
#  microchip              :string(255)
#  original_name          :string(255)
#  fee                    :integer
#  coordinator_id         :integer
#  sponsored_by           :string(255)
#  shelter_id             :integer
#  medical_summary        :text
#  heartworm_preventative :string
#  flea_tick_preventative :string
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
        expect(dog.adoption_date).to be

        dog.update_attribute(:status, 'adoptable')
        expect(dog.adoption_date).to be_nil
      end
    end
  end
end
