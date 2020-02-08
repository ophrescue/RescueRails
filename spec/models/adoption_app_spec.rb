# == Schema Information
#
# Table name: adoption_apps
#
#  id                        :integer          not null, primary key
#  adopter_id                :integer
#  spouse_name               :string(50)
#  other_household_names     :string(255)
#  ready_to_adopt_dt         :date
#  house_type                :string(40)
#  dog_exercise              :text
#  dog_stay_when_away        :string(100)
#  dog_vacation              :text
#  current_pets              :text
#  why_not_fixed             :text
#  current_pets_uptodate     :boolean
#  current_pets_uptodate_why :text
#  landlord_name             :string(100)
#  landlord_phone            :string(15)
#  rent_dog_restrictions     :text
#  surrender_pet_causes      :text
#  training_explain          :text
#  surrendered_pets          :text
#  created_at                :datetime
#  updated_at                :datetime
#  how_did_you_hear          :string(255)
#  pets_branch               :string(255)
#  current_pets_fixed        :boolean
#  rent_costs                :text
#  vet_info                  :text
#  max_hrs_alone             :integer
#  is_ofage                  :boolean
#  landlord_email            :string
#  shot_dhpp_dhlpp           :boolean
#  shot_fpv_fhv_fcv          :boolean
#  shot_rabies               :boolean
#  shot_bordetella           :boolean
#  shot_heartworm            :boolean
#  shot_flea_tick            :boolean
#  verify_home_auth          :boolean          default(FALSE)
#  has_family_under_18       :boolean
#  birth_date                :date
#

require 'rails_helper'

describe AdoptionApp do
  let(:adoption_app) { build(:adoption_app) }

  before :each do
    allow(Adopter).to receive(:chimp_check).and_return(true)
    allow(Adopter).to receive(:chimp_subscribe).and_return(true)
    # Travel to Jan 30th, 2020 at 01:30:44 UTC
    travel_to Time.local(2020, 1, 30, 1, 30, 44)
  end

  after do
    travel_back
  end

  context 'has a valid factory' do
    it 'saves' do
      expect(create(:adoption_app)).to be_valid
    end
  end

  describe '.adopter_age' do
    it 'returns nil when birth_date is nil' do
      adoption_app.birth_date = nil

      expect(adoption_app.adopter_age).to be nil
    end

    it 'returns 10 years when birth_date is 10 years before current date' do
      adoption_app.birth_date = 10.years.ago.to_date

      expect(adoption_app.adopter_age).to eq("10 years")
    end

    it 'returns 9 years when birth_date is 1 month before 10 years from current date' do
      adoption_app.birth_date = (10.years.ago + 1.month).to_date
      puts Time.now
      puts Time.zone.now
      expect(adoption_app.adopter_age).to eq("9 years")
    end

    it 'returns 9 years when birth_date is 1 day before 10 years from current date' do
      adoption_app.birth_date = (10.years.ago + 1.day).to_date
      expect(adoption_app.adopter_age).to eq("9 years")
    end

    it 'returns 1 year when birth_date is 1 year from current date' do
      adoption_app.birth_date = 1.year.ago.to_date

      expect(adoption_app.adopter_age).to eq("1 year")
    end
  end
end
