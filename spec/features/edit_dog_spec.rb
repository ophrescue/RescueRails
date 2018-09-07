require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/rspec_matchers'
require_relative '../helpers/client_validation_form_helpers'

feature 'edit a dog', js: true do
  include ClientValidationFormHelpers

  before do
    sign_in_as(active_user)
  end

  feature 'permitted access to fields' do
    let(:active_record_attributes){ [:created_at, :updated_at, :id].map(&:to_s) }
    let(:not_editable_attributes){ [:youtube_video_url, :petfinder_ad_url].map(&:to_s) }
    let(:all_database_attributes){ Dog.new.attributes.keys }
    let(:all_form_fields) { all_database_attributes - active_record_attributes - not_editable_attributes }

    before do
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
          expect(page).to have_no_field("dog_#{field}")
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
          expect(page).to have_no_field("dog_#{field}")
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
          expect(page).to have_field("dog_#{field}", disabled: true)
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
      visit edit_dogs_manager_path(create(:dog,
                                          name: 'Scout',
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
        expect(page).to have_selector '#manage_photos #no_photos', text: 'Scout has no photos'
        expect(page).to have_selector '#manage_attachments #no_attachments', text: 'Scout has no documents'
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

        # add photos
        click_link('Add a Photo')
        click_link('Add a Photo') # cannot add another input until the first one has been set
        expect(page.all('#new_dog_photo').length).to eq 1
        find("#new_dog_photo").set(Rails.root.join('spec','fixtures','photo','dog_pic.jpg').to_s)
        click_link('Add another Photo')
        all("#new_dog_photo")[1].set(Rails.root.join('spec','fixtures','photo','dog_pic.jpg').to_s)
        click_link('Add another Photo')
        page.all('#remove_photo').last.click
        expect(page.all('#new_dog_photo').length).to eq 2

        # add document attachments
        click_link('Add a Document')
        click_link('Add a Document')
        expect(page.all('#new_dog_attachment').length).to eq 1
        find('#new_dog_attachment').set(Rails.root.join('spec','fixtures', 'doc', 'sample.docx').to_s)
        click_link('Add another Document')
        all('#new_dog_attachment')[1].set(Rails.root.join('spec','fixtures', 'doc', 'sample.docx').to_s)
        click_link('Add another Document')
        page.all('#remove_attachment').last.click
        expect(page.all('#new_dog_attachment').length).to eq 2

        # 5 size variants created from each image upload, see app/models/photo.rb
        expect{ click_button('Submit') }.to change{Dir.glob(Rails.root.join('public','system','test','photos','*')).length}.by(10).
                                        and change{Dir.glob(Rails.root.join('public','system','test','attachments','*')).length}.by(2)

        dog = Dog.first
        expect(dog.name).to eq 'newname'
        expect(dog.tracking_id).to eq 555
        expect(dog.primary_breed_id).to eq primary_breed.id
        expect(dog.secondary_breed_id).to eq secondary_breed.id
        expect(dog.status).to eq 'adoption pending'
        expect(dog.age).to eq 'senior'
        expect(dog.size).to eq 'large'
        expect(dog.is_altered).to eq true
        expect(dog.gender).to eq 'Female'
        expect(dog.is_special_needs).to eq true
        expect(dog.no_dogs).to eq true
        expect(dog.no_cats).to eq true
        expect(dog.no_kids).to eq true
        expect(dog.description).to eq 'have a nice day'
        expect(dog.foster_id).to eq foster.id
        expect(dog.adoption_date).to eq nil # b/c of the update_adoption_date callback on Dog model
        expect(dog.is_uptodateonshots).to eq true
        expect(dog.intake_dt).to eq Date.new(2009,1,29)
        expect(dog.available_on_dt).to eq Date.new(2019,8,31)
        expect(dog.has_medical_need).to eq true
        expect(dog.is_high_priority).to eq true
        expect(dog.needs_photos).to eq true
        expect(dog.has_behavior_problem).to eq true
        expect(dog.needs_foster).to eq true
        expect(dog.craigslist_ad_url).to eq 'http://www.example.com/foo'
        expect(dog.first_shots).to eq 'some text'
        expect(dog.second_shots).to eq 'lorem ipsum'
        expect(dog.third_shots).to eq 'blah blah'
        expect(dog.rabies).to eq 'kablooie'
        expect(dog.vac_4dx).to eq 'schmutz'
        expect(dog.bordetella).to eq 'words'
        expect(dog.microchip).to eq '1234abcd'
        expect(dog.original_name).to eq 'Snoop Dogg'
        expect(dog.fee).to eq 333
        expect(dog.coordinator_id).to eq adoption_coordinator.id
        expect(dog.sponsored_by).to eq 'Harry Harker'
        expect(dog.shelter_id).to eq shelter.id
        expect(dog.medical_summary).to eq 'medical words'
        expect(dog.heartworm_preventative).to eq 'have a nice day'
        expect(dog.flea_tick_preventative).to eq 'born in a barn'
        expect(dog.medical_review_complete).to eq true
        expect(dog.behavior_summary).to eq 'words describing behaviour'
        expect(dog.photos.length).to eq 2

        expect(page_heading).to match 'newname'
        expect(page_heading).to match '555'
        expect(page.find('#breed').text).to match 'new primary breed'
        expect(page.find('#breed').text).to match 'new secondary breed'
        expect(page.find('#status').text).to eq 'Adoption Pending'
        expect(page.find('#age').text).to eq 'Senior'
        expect(page.find('#size').text).to eq 'Large-size'
        expect(page.find('#not_altered')).to have_x_icon
        expect(page.find('#gender').text).to eq 'Female'
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
        expect(page.all('#galleria .galleria-stage .galleria-image img').length).to eq 1
        expect(page.all('#galleria .galleria-thumbnails-container .galleria-image img').length).to eq 2
      end
    end

    describe 'cancel while editing' do
      it "should return to the dog profile" do
        click_link('Cancel')
        dog = Dog.first
        expect(page_heading).to eq "##{dog.tracking_id} #{dog.name}"
      end
    end

    context 'user enters invalid attributes --client-side validation' do
      context 'non-integer tracking id' do
        it "should not save, and should notify user" do
          fill_in(:dog_tracking_id, with: 'new_tracking_id') # tracking id must be integer
          expect{ click_button('Submit') }.not_to change{Dog.first.tracking_id}
          expect(validation_error_message_for(:dog_tracking_id).text).to eq "Tracking id must be numeric"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_tracking_id, with: '22')
          expect(validation_error_message_for(:dog_tracking_id)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'integer tracking id with whitespace' do
        it "should save, with server stripping whitespace" do
          fill_in(:dog_tracking_id, with: '  55 ')
          expect{ click_button('Submit') }.to change{Dog.first.tracking_id}.to 55
        end
      end

      context 'blank name' do
        it "should not save and should notify user" do
          fill_in(:dog_name, with: '')
          expect{ click_button('Submit') }.not_to change{Dog.first.name}
          expect(validation_error_message_for(:dog_name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_name, with: 'Fido')
          expect(validation_error_message_for(:dog_name)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'whitespace name' do
        it "should not save and should notify user" do
          fill_in(:dog_name, with: '  ')
          expect{ click_button('Submit') }.not_to change{Dog.first.name}
          expect(validation_error_message_for(:dog_name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_name, with: 'Fido')
          expect(validation_error_message_for(:dog_name)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'improperly formatted craigslist ad url' do
        it "should not save and should notify user" do
          fill_in(:dog_craigslist_ad_url, with: 'www.craigslist.com/foo/bar/baz')
          expect{ click_button('Submit') }.not_to change{Dog.first.craigslist_ad_url}
          expect(validation_error_message_for(:dog_craigslist_ad_url).text).to eq "please include 'http://'"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_craigslist_ad_url, with: 'http://www.craigslist.com/foo/bar/baz')
          expect(validation_error_message_for(:dog_craigslist_ad_url)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes letters' do
        it 'should not save and should notify user' do
          fill_in(:dog_fee, with: '$88')
          expect{ click_button('Submit') }.not_to change{Dog.first.fee}
          expect(validation_error_message_for(:dog_fee).text).to eq "must be a whole number, with no letters"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_fee, with: '88')
          expect(validation_error_message_for(:dog_fee)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes leading/trailing whitespace' do
        it 'should save' do
          fill_in(:dog_fee, with: ' 88 ')
          expect{ click_button('Submit') }.to change{Dog.first.fee}.to(88)
        end
      end
    end

    #uniqueness of name and tracking id
    context 'user enters invalid attributes --server-side validation' do
      let!(:fido){ create(:dog, name: "Fido", tracking_id: 100) }
      let!(:bruno){ create(:dog, name: "Bruno", tracking_id: 200) }

      context 'when the user edits and creates duplicate name' do
        it 'should not save and should notify the user' do
          visit edit_dogs_manager_path(bruno)
          fill_in(:dog_name, with: 'fido')
          expect{ click_button('Submit') }.not_to change{ bruno.name }
          expect(page_heading).to eq 'Edit Dog'
          expect(page.find('#dog_name')).to have_class 'is-invalid'
          expect(validation_error_message_for(:dog_name)).to be_visible
          expect(validation_error_message_for(:dog_name).text).to eq 'Name has already been taken'
          expect(flash_error_message).to eq "form could not be saved, see errors below"
        end
      end

      context 'when the user edits and creates duplicate tracking_id' do
        it 'should not save and should notify the user' do
          visit edit_dogs_manager_path(bruno)
          fill_in(:dog_tracking_id, with: '100')
          expect{ click_button('Submit') }.not_to change{ bruno.tracking_id }
          expect(page_heading).to eq 'Edit Dog'
          expect(page.find('#dog_tracking_id')).to have_class 'is-invalid'
          expect(validation_error_message_for(:dog_tracking_id)).to be_visible
          expect(validation_error_message_for(:dog_tracking_id).text).to eq 'Tracking id has already been taken'
          expect(flash_error_message).to eq "form could not be saved, see errors below"
        end
      end
    end
  end
end
