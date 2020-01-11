require 'rails_helper'
require_relative '../../helpers/application_helpers'
require_relative '../../helpers/rspec_matchers'
require_relative '../../helpers/client_validation_form_helpers'
require_relative '../../helpers/cats_list_helper'

feature 'add a cat', js: true do
  include ClientValidationFormHelpers
  include ApplicationHelpers

  feature 'permitted access to fields' do
    let(:active_record_attributes){ [:created_at, :updated_at, :id].map(&:to_s) }
    let(:not_editable_attributes){ [:youtube_video_url, :petfinder_ad_url, :tracking_id].map(&:to_s) }
    let(:all_database_attributes){ Cat.new.attributes.keys }
    let(:all_form_fields) { all_database_attributes - active_record_attributes - not_editable_attributes }

    before do
      sign_in_as(active_user)
      visit new_cats_manager_path
    end

    context 'user not permitted to manage_medical_behavior' do
      let!(:active_user) { create(:user, :admin, medical_behavior_permission: false ) }
      let(:disallowed_fields){ ['medical_summary', 'behavior_summary'] }

      it 'should allow access to all fields except medical summary' do
        (all_form_fields - disallowed_fields).each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end

      it 'should not show headings or inputs for medical summary and behavior summary' do
        disallowed_fields.each do |field|
          expect(page).to have_field("cat_#{field}", disabled: true)
        end
      end
    end

    context 'user has all permissions' do
      let!(:active_user) { create(:user, :admin) }

      it 'should allow access to all fields' do
        all_form_fields.each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end
    end
  end

  feature "save attributes" do
    include ApplicationHelpers
    include CatsListHelper

    let!(:active_user) { create(:user, :admin) }
    let!(:primary_breed){ create(:cat_breed, name: 'new primary breed') }
    let!(:secondary_breed){ create(:cat_breed, name: 'new secondary breed') }
    let!(:foster){ create(:foster, name: 'Dede Catlady') }
    let!(:adoption_coordinator){ create(:adoption_coordinator) }
    let!(:shelter){ create(:shelter) }

    before do
      sign_in_as(active_user)
      visit new_cats_manager_path
    end

    context 'user enters valid attributes', exclude_ie: true do
      it "should save the user-entered values" do
        fill_in(:cat_name, with: 'newname')
        select('new primary breed', from: 'cat_primary_breed_id')
        select('new secondary breed', from: 'cat_secondary_breed_id')
        select('adoption pending', from: 'cat_status')
        select('senior', from: 'cat_age')
        select('large', from: 'cat_size')
        select('medium', from: 'cat_coat_length')
        check(:cat_is_altered)
        select('Female', from: 'cat_gender')
        check(:cat_is_special_needs)
        check(:cat_no_dogs)
        check(:cat_no_cats)
        check(:cat_no_kids)
        fill_in(:cat_description, with: 'have a nice day')
        select('Dede Catlady', from: 'cat_foster_id')
        fill_in(:cat_adoption_date, with: "2010-8-28")
        check(:cat_is_uptodateonshots)
        fill_in(:cat_intake_dt, with: "2009-1-29")
        fill_in(:cat_available_on_dt, with: "2019-8-31")
        check(:cat_declawed)
        check(:cat_litter_box_trained)
        check(:cat_has_medical_need)
        check(:cat_is_high_priority)
        check(:cat_needs_photos)
        check(:cat_has_behavior_problem)
        check(:cat_needs_foster)
        fill_in(:cat_craigslist_ad_url, with: 'http://www.example.com/foo')
        fill_in(:cat_first_shots, with: 'some text')
        fill_in(:cat_second_shots, with: 'lorem ipsum')
        fill_in(:cat_third_shots, with: 'blah blah')
        fill_in(:cat_rabies, with: 'kablooie')
        fill_in(:cat_felv_fiv_test, with: 'schmutz')
        fill_in(:cat_flea_tick_preventative, with: 'born in a barn')
        fill_in(:cat_dewormer, with: 'duis aute')
        fill_in(:cat_coccidia_treatment, with: 'have a nice day')
        fill_in(:cat_microchip, with: '1234abcd')
        fill_in(:cat_original_name, with: 'Snoop Catt')
        fill_in(:cat_fee, with: '333')
        select(adoption_coordinator.name, from: 'cat_coordinator_id')
        fill_in(:cat_sponsored_by, with: 'Harry Harker')
        select(shelter.name, from: 'cat_shelter_id')
        fill_in(:cat_medical_summary, with: 'medical words')
        check(:cat_medical_review_complete)
        fill_in(:cat_behavior_summary, with: 'words describing behaviour')

        # add photos
        click_link('Add a Photo')
        click_link('Add a Photo') # cannot add another input until the first one has been set
        expect(page.all('#new_cat_photo').length).to eq 1
        find("#new_cat_photo").set(Rails.root.join('spec','fixtures','photo','animal_pic.jpg').to_s)
        click_link('Add another Photo')
        all("#new_cat_photo")[1].set(Rails.root.join('spec','fixtures','photo','animal_pic.jpg').to_s)
        click_link('Add another Photo')
        page.all('#remove_photo').last.click
        expect(page.all('#new_cat_photo').length).to eq 2

        # add document attachments
        click_link('Add a Document')
        click_link('Add a Document')
        expect(page.all('#new_cat_attachment').length).to eq 1
        find('#new_cat_attachment').set(Rails.root.join('spec','fixtures', 'doc', 'sample.docx').to_s)
        click_link('Add another Document')
        all('#new_cat_attachment')[1].set(Rails.root.join('spec','fixtures', 'doc', 'sample.docx').to_s)
        click_link('Add another Document')
        page.all('#remove_attachment').last.click
        expect(page.all('#new_cat_attachment').length).to eq 2

        # 5 size variants created from each image upload, see app/models/photo.rb
        expect{ click_button('Submit') }.to change{Dir.glob(Rails.root.join('public','system','test','photos','*')).length}.by(10).
                                        and change{Dir.glob(Rails.root.join('public','system','test','attachments','*')).length}.by(2)

        cat = Cat.first
        expect(cat.name).to eq 'newname'
        expect(cat.primary_breed_id).to eq primary_breed.id
        expect(cat.secondary_breed_id).to eq secondary_breed.id
        expect(cat.status).to eq 'adoption pending'
        expect(cat.age).to eq 'senior'
        expect(cat.size).to eq 'large'
        expect(cat.coat_length).to eq 'medium'
        expect(cat.is_altered).to eq true
        expect(cat.gender).to eq 'Female'
        expect(cat.is_special_needs).to eq true
        expect(cat.declawed).to eq true
        expect(cat.litter_box_trained).to eq true
        expect(cat.no_dogs).to eq true
        expect(cat.no_cats).to eq true
        expect(cat.no_kids).to eq true
        expect(cat.description).to eq 'have a nice day'
        expect(cat.foster_id).to eq foster.id
        expect(cat.adoption_date).to eq nil # b/c of the update_adoption_date callback on Dog model
        expect(cat.is_uptodateonshots).to eq true
        expect(cat.intake_dt).to eq Date.new(2009,1,29)
        expect(cat.available_on_dt).to eq Date.new(2019,8,31)
        expect(cat.has_medical_need).to eq true
        expect(cat.is_high_priority).to eq true
        expect(cat.needs_photos).to eq true
        expect(cat.has_behavior_problem).to eq true
        expect(cat.needs_foster).to eq true
        expect(cat.craigslist_ad_url).to eq 'http://www.example.com/foo'
        expect(cat.first_shots).to eq 'some text'
        expect(cat.second_shots).to eq 'lorem ipsum'
        expect(cat.third_shots).to eq 'blah blah'
        expect(cat.rabies).to eq 'kablooie'
        expect(cat.felv_fiv_test).to eq 'schmutz'
        expect(cat.flea_tick_preventative).to eq 'born in a barn'
        expect(cat.dewormer).to eq 'duis aute'
        expect(cat.coccidia_treatment).to eq 'have a nice day'
        expect(cat.microchip).to eq '1234abcd'
        expect(cat.original_name).to eq 'Snoop Catt'
        expect(cat.fee).to eq 333
        expect(cat.coordinator_id).to eq adoption_coordinator.id
        expect(cat.sponsored_by).to eq 'Harry Harker'
        expect(cat.shelter_id).to eq shelter.id
        expect(cat.medical_summary).to eq 'medical words'

        expect(cat.medical_review_complete).to eq true
        expect(cat.behavior_summary).to eq 'words describing behaviour'

        expect(cat.photos.length).to eq 2

        expect(page_heading).to match 'Cat Manager'
        expect(cat_names).to include('newname')
      end
    end

    describe 'cancel while adding' do
      it "should return to the cat manager page" do
        click_link('Cancel')
        expect(page_heading).to eq 'Cat Manager'
      end
    end

    context 'user enters invalid attributes --client-side validation' do
      context 'no status selected' do
        it "should not save and should notify user" do
          fill_in(:cat_name, with: 'Fido')
          expect{ click_button('Submit') }.not_to change{Cat.count}
          expect(validation_error_message_for(:cat_status).text).to eq "Status must be selected"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          select('adoption pending', from: 'cat_status')
          fill_in(:cat_name, with: 'Fido')
          expect(validation_error_message_for(:cat_status)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'blank name' do
        it "should not save and should notify user" do
          select('adoption pending', from: 'cat_status')
          expect{ click_button('Submit') }.not_to change{Cat.count}
          expect(validation_error_message_for(:cat_name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_name, with: 'Fido')
          expect(validation_error_message_for(:cat_name)).not_to be_visible
          select('adoption pending', from: 'cat_status')
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'with any of the Faker names' do
        it "should validate the name on the browser" do
          click_button('Submit')
          expect(validation_error_message_for(:cat_name).text).to eq "Name cannot be blank"
          # here we test against just 30 names, for performance reasons
          # if any changes are made to this code it would be wise to
          # remove the .sample(30) and verify code against all the names
          names = I18n.t('faker.cat.name').sample(30)
          names.each do |name|
            fill_in(:cat_name, with: name)
            expect(validation_error_message_for(:cat_name)).not_to be_visible
          end
        end
      end

      context 'whitespace name' do
        it "should not save and should notify user" do
          select('adoption pending', from: 'cat_status')
          fill_in(:cat_name, with: '  ')
          expect{ click_button('Submit') }.not_to change{Cat.count}
          expect(validation_error_message_for(:cat_name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_name, with: 'Fido')
          expect(validation_error_message_for(:cat_name)).not_to be_visible
          select('adoption pending', from: 'cat_status')
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'name with legitimate whitespace' do
        it "should save" do
          expect(1).to eq 1
          fill_in(:cat_name, with: ' Fido Smith ')
          select('adoption pending', from: 'cat_status')
          expect{ click_button('Submit') }.to change{Cat.count}.by(1)
          expect(Cat.first.name).to eq "Fido Smith"
        end
      end

      context 'name with acceptable punctuation' do
        it "should save" do
          fill_in(:cat_name, with: ' B.B. Mc-Fido ')
          select('adoption pending', from: 'cat_status')
          expect{ click_button('Submit') }.to change{Cat.count}.by(1)
          expect(Cat.first.name).to eq "B.B. Mc-Fido"
        end
      end

      context 'improperly formatted craigslist ad url' do
        it "should not save and should notify user" do
          fill_in(:cat_name, with: 'Fido')
          select('adoption pending', from: 'cat_status')
          fill_in(:cat_craigslist_ad_url, with: 'www.craigslist.com/foo/bar/baz')
          expect{ click_button('Submit') }.not_to change{Cat.count}
          expect(validation_error_message_for(:cat_craigslist_ad_url).text).to eq "please include 'http://'"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_craigslist_ad_url, with: 'http://www.craigslist.com/foo/bar/baz')
          expect(validation_error_message_for(:cat_craigslist_ad_url)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes letters' do
        it 'should not save and should notify user' do
          select('adoption pending', from: 'cat_status')
          fill_in(:cat_name, with: 'Fido')
          select('adoption pending', from: 'cat_status')
          fill_in(:cat_fee, with: '$88')
          expect{ click_button('Submit') }.not_to change{Cat.count}
          expect(validation_error_message_for(:cat_fee).text).to eq "must be a whole number, with no letters"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_fee, with: '88')
          expect(validation_error_message_for(:cat_fee)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes leading/trailing whitespace' do
        it 'should save' do
          fill_in(:cat_name, with: 'Fido')
          fill_in(:cat_fee, with: ' 88 ')
          select('adoption pending', from: 'cat_status')
          click_button('Submit')
          expect(Cat.first.fee).to eq 88
        end
      end

      context 'photo exceeds limit' do
        before do
          stub_const("Photo::PHOTO_MAX_SIZE", 1)
          visit new_cats_manager_path
        end

        it 'should not save and should warn user' do
          click_link('Add a Photo')
          find("#new_cat_photo").set(Rails.root.join('spec','fixtures','photo','animal_large_pic.jpg').to_s)
          expect{ click_button('Submit') }.not_to change{Dir.glob(Rails.root.join('public','system','test','photos','*')).length}
          expect(page).to have_selector('.new_photos .invalid-feedback', text: 'must be a jpg or png file smaller than 10Mb')
        end
      end

      context 'photo is wrong type' do
        it 'should not save and should warn user' do
          click_link('Add a Photo')
          find("#new_cat_photo").set(Rails.root.join('spec','fixtures','doc','sample.pdf').to_s)
          expect{ click_button('Submit') }.not_to change{Dir.glob(Rails.root.join('public','system','test','photos','*')).length}
          expect(page).to have_selector('.new_photos .invalid-feedback', text: 'must be a jpg or png file smaller than 10Mb')
        end
      end

      context 'attachment exceeds limit' do
        before do
          stub_const("Attachment::ATTACHMENT_MAX_SIZE", 1)
          visit new_cats_manager_path
        end

        it 'should not save and should warn user' do
          click_link('Add a Document')
          find("#new_cat_attachment").set(Rails.root.join('spec','fixtures','doc','sample_large.pdf').to_s)
          expect{ click_button('Submit') }.not_to change{Dir.glob(Rails.root.join('public','system','test','attachments','*')).length}
          expect(page).to have_selector('.new_attachments .invalid-feedback', text: 'Images, MS Docs, PDF or Plain Text smaller than 100Mb')
        end
      end

      context 'attachment is wrong type' do
        it 'should not save and should warn user' do
          click_link('Add a Document')
          find("#new_cat_attachment").set(Rails.root.join('spec','fixtures','doc','sample.rb').to_s)
          expect{ click_button('Submit') }.not_to change{Dir.glob(Rails.root.join('public','system','test','attachments','*')).length}
          expect(page).to have_selector('.new_attachments .invalid-feedback', text: 'Images, MS Docs, PDF or Plain Text smaller than 100Mb')
        end
      end
    end

    #uniqueness of name validated on server
    context 'user enters invalid attributes --server-side validation' do
      let!(:fido){ create(:cat, name: "Fido") }

      context 'when the user adds a dog with a duplicate name' do
        it 'should not save and should notify the user' do
          visit new_cats_manager_path
          fill_in(:cat_name, with: 'fido')
          select('adoption pending', from: 'cat_status')
          expect{ click_button('Submit') }.not_to change{ Cat.count }
          expect(page_heading).to eq 'Add a New Cat'
          expect(page.find('#cat_name')).to have_class 'is-invalid'
          expect(validation_error_message_for(:cat_name)).to be_visible
          expect(validation_error_message_for(:cat_name).text).to eq 'Name has already been taken'
          expect(flash_error_message).to eq "form could not be saved, see errors below"
        end
      end
    end
  end
end
