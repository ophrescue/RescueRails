require 'rails_helper'

feature 'edit a dog', js: true do
  feature 'permitted access to fields' do
   let(:all_fields) { ['tracking_id', 'name', 'original_name', 'microchip', 'fee', 'intake_dt', 'available_on_dt',
                       'adoption_date', 'sponsored_by', 'craigslist_ad_url', 'first_shots', 'second_shots', 'third_shots',
                       'rabies', 'vac_4dx', 'bordetella', 'heartworm_preventative', 'flea_tick_preventative', 'primary_breed_id',
                       'secondary_breed_id', 'foster_id', 'coordinator_id', 'shelter_id', 'status', 'gender',
                       'age', 'size', 'is_uptodateonshots', 'is_altered', 'is_special_needs', 'no_dogs',
                       'no_cats', 'no_kids', 'medical_review_complete', 'has_medical_need', 'is_high_priority',
                       'needs_photos', 'has_behavior_problem', 'needs_foster', 'description', 'medical_summary', 'behavior_summary'] }
    before do
      sign_in(active_user)
      visit edit_dogs_manager_path(create(:dog))
    end

    context 'user not permitted to add dogs' do
      let!(:active_user) { create(:user, :admin, add_dogs: false) }
      let(:disallowed_fields) { ['primary_breed_id', 'secondary_breed_id'] }

      it 'should allow access to all fields except breed fields' do
        (all_fields - disallowed_fields).each do |field|
          expect(page.find("#dog_#{field}")).not_to be_disabled
        end
      end

      it 'should show values instead of inputs for breed attributes' do
        disallowed_fields.each do |field|
          expect(page).not_to have_field("dog_#{field}")
        end
      end
    end

    context 'user not permitted to edit adopters and not permitted to add dogs' do
      let!(:active_user) { create(:user, :admin, add_dogs: false, edit_all_adopters: false) }
      let(:disallowed_fields) { ['primary_breed_id', 'secondary_breed_id', 'coordinator_id'] }

      it 'should allow access to all except breed fields and coordinators field' do
        (all_fields - disallowed_fields).each do |field|
          expect(page.find("#dog_#{field}")).not_to be_disabled
        end
      end

      it 'should show values instead of inputs for breed attributes and coordinator field' do
        disallowed_fields.each do |field|
          expect(page).not_to have_field("dog_#{field}")
        end
      end
    end

    context 'user not permitted to manage_medical_behavior' do
      let!(:active_user) { create(:user, :admin, medical_behavior_permission: false ) }
      let(:disallowed_fields){ ['medical_summary', 'behavior_summary'] }

      it 'should allow access to all fields except medical summary' do
        (all_fields - disallowed_fields).each do |field|
          expect(page.find("#dog_#{field}")).not_to be_disabled
        end
      end

      it 'should show values instead of inputs for medical summary and behavior summary' do
        disallowed_fields.each do |field|
          expect(page).not_to have_field("dog_#{field}")
        end
      end
    end

    context 'user has all permissions' do
      let!(:active_user) { create(:user, :admin) }

      it 'should allow access to all fields' do
        all_fields.each do |field|
          expect(page.find("#dog_#{field}")).not_to be_disabled
        end
      end
    end
  end
end
