require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/rspec_matchers'

feature 'edit a dog', js: true do
  feature 'permitted access to fields' do
    let(:active_record_attributes){ [:created_at, :updated_at, :id].map(&:to_s) }
    let(:not_editable_attributes){ [:youtube_video_url, :petfinder_ad_url].map(&:to_s) }
    let(:all_database_attributes){ Dog.new.attributes.keys }
    let(:all_form_fields) { all_database_attributes - active_record_attributes - not_editable_attributes }

    before do
      sign_in(active_user)
      visit edit_dogs_manager_path(create(:dog))
    end

    context 'user not permitted to add dogs' do
      let!(:active_user) { create(:user, :admin, add_dogs: false) }
      let(:disallowed_fields) { ['primary_breed_id', 'secondary_breed_id'] }

      it 'should allow access to all fields except breed fields' do
        (all_form_fields - disallowed_fields).each do |field|
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
        (all_form_fields - disallowed_fields).each do |field|
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
        (all_form_fields - disallowed_fields).each do |field|
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
        all_form_fields.each do |field|
          expect(page.find("#dog_#{field}")).not_to be_disabled
        end
      end
    end
  end

  feature "change and save attributes" do
    include ApplicationHelpers

    let!(:active_user) { create(:user, :admin) }
    let!(:primary_breed){ create(:breed, name: 'new primary breed') }
    let!(:secondary_breed){ create(:breed, name: 'new secondary breed') }
    let!(:foster){ create(:foster, name: 'Dede Doglady') }
    let!(:adoption_coordinator){ create(:adoption_coordinator) }
    let!(:shelter){ create(:shelter) }

    before do
      sign_in(active_user)
      visit edit_dogs_manager_path(create(:dog,
                                          status: 'adoptable',
                                          age: 'baby',
                                          size: 'small',
                                          is_altered: false,
                                          gender: 'Male',
                                          is_special_needs: false,
                                          no_dogs: false,
                                          no_cats: false,
                                          no_kids: false,
                                          description: nil,
                                          original_name: nil,
                                          microchip: nil,
                                          fee: nil,
                                          shelter_id: nil,
                                          available_on_dt: nil,
                                          intake_dt: nil,
                                          adoption_date: nil))
    end

    context 'user enters valid attributes' do
      it "should save the updated values" do
        fill_in(:dog_name, with: 'newname')
        fill_in(:dog_tracking_id, with: '555')
        select('new primary breed', from: 'dog_primary_breed_id')
        select('new secondary breed', from: 'dog_secondary_breed_id')
        select('adoption pending', from: 'dog_status')
        select('senior', from: 'dog_age')
        select('large', from: 'dog_size')
        check(:dog_is_altered)
        select('Female', from: 'dog_gender')
        check(:dog_is_special_needs)
        check(:dog_no_dogs)
        check(:dog_no_cats)
        check(:dog_no_kids)
        fill_in(:dog_description, with: 'have a nice day')
        select('Dede Doglady', from: 'dog_foster_id')
        fill_in(:dog_adoption_date, with: "2010-8-28")
        check(:dog_is_uptodateonshots)
        fill_in(:dog_intake_dt, with: "2009-1-29")
        fill_in(:dog_available_on_dt, with: "2019-8-31")
        check(:dog_has_medical_need)
        check(:dog_is_high_priority)
        check(:dog_needs_photos)
        check(:dog_has_behavior_problem)
        check(:dog_needs_foster)
        fill_in(:dog_craigslist_ad_url, with: 'http://www.example.com/foo')
        fill_in(:dog_first_shots, with: 'some text')
        fill_in(:dog_second_shots, with: 'lorem ipsum')
        fill_in(:dog_third_shots, with: 'blah blah')
        fill_in(:dog_rabies, with: 'kablooie')
        fill_in(:dog_vac_4dx, with: 'schmutz')
        fill_in(:dog_bordetella, with: 'words')
        fill_in(:dog_microchip, with: '1234abcd')
        fill_in(:dog_original_name, with: 'Snoop Dogg')
        fill_in(:dog_fee, with: '333')
        select(adoption_coordinator.name, from: 'dog_coordinator_id')
        fill_in(:dog_sponsored_by, with: 'Harry Harker')
        select(shelter.name, from: 'dog_shelter_id')
        fill_in(:dog_medical_summary, with: 'medical words')
        fill_in(:dog_heartworm_preventative, with: 'have a nice day')
        fill_in(:dog_flea_tick_preventative, with: 'born in a barn')
        check(:dog_medical_review_complete)
        fill_in(:dog_behavior_summary, with: 'words describing behaviour')
        all(:xpath, './/input[contains(@id,"dog_photos")]').first.set('')
        expect(1).to eq 0 # to flag the tests to be written for:
                          # photos
                          # documents

        click_button('Submit')

        saved_attributes = Dog.first
        expect(saved_attributes.name).to eq 'newname'
        expect(saved_attributes.tracking_id).to eq 555
        expect(saved_attributes.primary_breed_id).to eq primary_breed.id
        expect(saved_attributes.secondary_breed_id).to eq secondary_breed.id
        expect(saved_attributes.status).to eq 'adoption pending'
        expect(saved_attributes.age).to eq 'senior'
        expect(saved_attributes.size).to eq 'large'
        expect(saved_attributes.is_altered).to eq true
        expect(saved_attributes.gender).to eq 'Female'
        expect(saved_attributes.is_special_needs).to eq true
        expect(saved_attributes.no_dogs).to eq true
        expect(saved_attributes.no_cats).to eq true
        expect(saved_attributes.no_kids).to eq true
        expect(saved_attributes.description).to eq 'have a nice day'
        expect(saved_attributes.foster_id).to eq foster.id
        expect(saved_attributes.adoption_date).to eq nil # b/c of the update_adoption_date callback on Dog model
        expect(saved_attributes.is_uptodateonshots).to eq true
        expect(saved_attributes.intake_dt).to eq Date.new(2009,1,29)
        expect(saved_attributes.available_on_dt).to eq Date.new(2019,8,31)
        expect(saved_attributes.has_medical_need).to eq true
        expect(saved_attributes.is_high_priority).to eq true
        expect(saved_attributes.needs_photos).to eq true
        expect(saved_attributes.has_behavior_problem).to eq true
        expect(saved_attributes.needs_foster).to eq true
        expect(saved_attributes.craigslist_ad_url).to eq 'http://www.example.com/foo'
        expect(saved_attributes.first_shots).to eq 'some text'
        expect(saved_attributes.second_shots).to eq 'lorem ipsum'
        expect(saved_attributes.third_shots).to eq 'blah blah'
        expect(saved_attributes.rabies).to eq 'kablooie'
        expect(saved_attributes.vac_4dx).to eq 'schmutz'
        expect(saved_attributes.bordetella).to eq 'words'
        expect(saved_attributes.microchip).to eq '1234abcd'
        expect(saved_attributes.original_name).to eq 'Snoop Dogg'
        expect(saved_attributes.fee).to eq 333
        expect(saved_attributes.coordinator_id).to eq adoption_coordinator.id
        expect(saved_attributes.sponsored_by).to eq 'Harry Harker'
        expect(saved_attributes.shelter_id).to eq shelter.id
        expect(saved_attributes.medical_summary).to eq 'medical words'
        expect(saved_attributes.heartworm_preventative).to eq 'have a nice day'
        expect(saved_attributes.flea_tick_preventative).to eq 'born in a barn'
        expect(saved_attributes.medical_review_complete).to eq true
        expect(saved_attributes.behavior_summary).to eq 'words describing behaviour'

        expect(page_heading).to match 'newname'
        expect(page_heading).to match '555'
        expect(page.find('#breed').text).to match 'new primary breed'
        expect(page.find('#breed').text).to match 'new secondary breed'
        expect(page.find('#status').text).to eq 'Adoption Pending'
        expect(page.find('#age').text).to eq 'Senior'
        expect(page.find('#size').text).to eq 'Large-size,'
        expect(page.find('#not_altered')).to have_x_icon
        expect(page.find('#gender').text).to eq 'Female,'
        expect(page.find('#special_needs')).to have_check_icon
        expect(page.find('#dogs_ok')).to have_x_icon
        expect(page.find('#cats_ok')).to have_x_icon
        expect(page.find('#kids_ok')).to have_x_icon
        expect(page.find('#dogDescription').text).to match 'have a nice day'
        expect(page.find('#foster').text).to match foster.name
        expect(page.find('#adoption_date').text).to eq 'unknown'
        expect(page.find('#is_uptodateonshots')).to have_check_icon
        expect(page.find('#intake_dt').text).to eq "2009-01-29"
        expect(page.find('#available_on_dt').text).to eq "2019-08-31"
        expect(page.find('#has_medical_need')).to have_check_icon
        expect(page.find('#is_high_priority')).to have_check_icon
        expect(page.find('#needs_photos')).to have_check_icon
        expect(page.find('#has_behaviour_problem')).to have_check_icon
        expect(page.find('#needs_foster')).to have_check_icon
        expect(page.find('#craigslist_ad_url').text).to eq 'Craigslist'
        expect(page.find('#craigslist_ad_url a')['href']).to eq 'http://www.example.com/foo'
        expect(page.find('#first_shots').text).to eq 'some text'
        expect(page.find('#second_shots').text).to eq 'lorem ipsum'
        expect(page.find('#third_shots').text).to eq 'blah blah'
        expect(page.find('#rabies').text).to eq 'kablooie'
        expect(page.find('#vac_4dx').text).to eq 'schmutz'
        expect(page.find('#bordetella').text).to eq 'words'
        expect(page.find('#microchip').text).to eq '1234abcd'
        expect(page.find('#original_name').text).to eq 'Snoop Dogg'
        expect(page.find('#fee').text).to eq '$333'
        expect(page.find('#adoption_coordinator').text).to eq adoption_coordinator.name
        expect(page.find('#sponsored_by').text).to eq 'Harry Harker'
        expect(page.find('#shelter').text).to eq shelter.name
        expect(page.find('#medical_summary').text).to eq 'medical words'
        expect(page.find('#heartworm_preventative').text).to eq 'have a nice day'
        expect(page.find('#flea_tick_preventative').text).to eq 'born in a barn'
        expect(page.find('#medical_review_complete')).to have_check_icon
        expect(page.find('#behavior_summary').text).to eq 'words describing behaviour'
      end
    end

    context 'user enters invalid attributes' do
      it "should not save, and should notify user" do
        fill_in(:dog_tracking_id, with: 'new_tracking_id')
        # show required format for dates
        # and error msg when format is entered wrong
        # craigslist add url must include http
        # adoption fee must be integer
        click_button('Submit')
      end
    end
  end
end
