require 'rails_helper'
require_relative '../../helpers/application_helpers'
require_relative '../../helpers/rspec_matchers'
require_relative '../../helpers/client_validation_form_helpers'

feature 'edit a cat', js: true do
  include ClientValidationFormHelpers

  before do
    sign_in_as(active_user)
  end

  feature 'permitted access to fields' do
    let(:active_record_attributes){ [:created_at, :updated_at, :id].map(&:to_s) }
    let(:not_editable_attributes){ [:youtube_video_url, :petfinder_ad_url].map(&:to_s) }
    let(:all_database_attributes){ Cat.new.attributes.keys }
    let(:all_form_fields) { all_database_attributes - active_record_attributes - not_editable_attributes }

    context 'user not permitted to add cats' do
      let!(:cat) { create(:cat) }
      let!(:active_user) { create(:user, :admin, add_dogs: false) }
      let(:disallowed_fields) { ['name','original_name','primary_breed_id', 'secondary_breed_id'] }

      it 'should allow access to all fields except breed fields and status' do
        visit edit_cats_manager_path(cat)
        (all_form_fields - disallowed_fields).each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end

      it 'should show disallowed fields as disabled' do
        visit edit_cats_manager_path(cat)
        disallowed_fields.each do |field|
          expect(page).to have_field("cat_#{field}", disabled: true)
        end
      end
    end

    context 'user not permitted to edit adopters and not permitted to add cats' do
      let!(:cat) { create(:cat) }
      let!(:active_user) { create(:user, :admin, add_dogs: false, edit_all_adopters: false) }
      let(:disallowed_fields) { ['name','original_name','primary_breed_id', 'secondary_breed_id', 'coordinator_id'] }

      it 'should allow access to all except breed fields and coordinators field' do
        visit edit_cats_manager_path(cat)
        (all_form_fields - disallowed_fields).each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end

      it 'should show disabled inputs for breed attributes and coordinator field' do
        visit edit_cats_manager_path(cat)
        disallowed_fields.each do |field|
          expect(page).to have_field("cat_#{field}", disabled: true)
        end
      end
    end

    context 'user not permitted to manage_medical_behavior' do
      let!(:cat) { create(:cat) }
      let!(:active_user) { create(:user, :admin, medical_behavior_permission: false ) }
      let(:disallowed_fields){ ['medical_summary', 'behavior_summary'] }

      it 'should allow access to all fields except medical summary' do
        visit edit_cats_manager_path(cat)
        (all_form_fields - disallowed_fields).each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end

      it 'should show disabled inputs for medical summary and behavior summary' do
        visit edit_cats_manager_path(cat)
        disallowed_fields.each do |field|
          expect(page).to have_field("cat_#{field}", disabled: true)
        end
      end
    end

    context 'user is fostering the cat' do
      let!(:active_user) { create(:user, :foster) }
      let!(:cat) { create(:cat, foster_id: active_user.id) }
      let(:disallowed_fields){ %w[tracking_id name original_name fee medical_summary behavior_summary status primary_breed_id secondary_breed_id coordinator_id] }

      it 'should allow access to limited foster fields' do
        visit edit_cats_manager_path(cat)
        (all_form_fields - disallowed_fields).each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end

      it 'should show disabled inputs for foster disallowed fields' do
        visit edit_cats_manager_path(cat)
        disallowed_fields.each do |field|
          expect(page).to have_field("cat_#{field}", disabled: true)
        end
      end
    end

    context 'user has all permissions' do
      let!(:active_user) { create(:user, :admin) }
      let!(:cat) { create(:cat) }

      it 'should allow access to all fields' do
        visit edit_cats_manager_path(cat)
        all_form_fields.each do |field|
          expect(page.find("#cat_#{field}")).not_to be_disabled
        end
      end
    end
  end

  feature "change and save attributes" do
    include ApplicationHelpers

    let!(:active_user) { create(:user, :admin) }
    let!(:primary_breed){ create(:cat_breed, name: 'new primary breed') }
    let!(:secondary_breed){ create(:cat_breed, name: 'new secondary breed') }
    let!(:foster){ create(:foster, name: 'Dede Doglady') }
    let!(:adoption_coordinator){ create(:adoption_coordinator) }
    let!(:shelter){ create(:shelter) }

    before do
      visit edit_cats_manager_path(create(:cat,
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
        fill_in(:cat_name, with: 'newname')
        fill_in(:cat_tracking_id, with: '555')
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
        select('Dede Doglady', from: 'cat_foster_id')
        fill_in(:cat_adoption_date, with: "2010-8-28")
        check(:cat_is_uptodateonshots)
        fill_in(:cat_intake_dt, with: "2009-1-29")
        fill_in(:cat_available_on_dt, with: "2019-8-31")
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
        fill_in(:cat_flea_tick_preventative, with: 'words')
        fill_in(:cat_dewormer, with: 'duis aute')
        fill_in(:cat_coccidia_treatment, with: 'excepteur sint')
        fill_in(:cat_microchip, with: '923456789a')
        fill_in(:cat_original_name, with: 'Snoop Dogg')
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
        expect(cat.tracking_id).to eq 555
        expect(cat.primary_breed_id).to eq primary_breed.id
        expect(cat.secondary_breed_id).to eq secondary_breed.id
        expect(cat.status).to eq 'adoption pending'
        expect(cat.age).to eq 'senior'
        expect(cat.size).to eq 'large'
        expect(cat.is_altered).to eq true
        expect(cat.gender).to eq 'Female'
        expect(cat.is_special_needs).to eq true
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
        expect(cat.flea_tick_preventative).to eq 'words'
        expect(cat.dewormer).to eq 'duis aute'
        expect(cat.coccidia_treatment).to eq 'excepteur sint'
        expect(cat.microchip).to eq '923456789a'
        expect(cat.original_name).to eq 'Snoop Dogg'
        expect(cat.fee).to eq 333
        expect(cat.coordinator_id).to eq adoption_coordinator.id
        expect(cat.sponsored_by).to eq 'Harry Harker'
        expect(cat.shelter_id).to eq shelter.id
        expect(cat.medical_summary).to eq 'medical words'
        expect(cat.medical_review_complete).to eq true
        expect(cat.behavior_summary).to eq 'words describing behaviour'

        expect(cat.photos.length).to eq 2

        expect(page_heading).to match 'newname'
        expect(page_heading).to match '555'
        expect(page.find('#breed').text).to match 'new primary breed'
        expect(page.find('#breed').text).to match 'new secondary breed'
        expect(page.find('#status').text).to eq 'Adoption Pending'
        expect(page.find('#age').text).to eq 'Senior'
        expect(page.find('#size').text).to eq 'Large-size'
        expect(page.find('#coat_length').text).to eq 'Medium coat length'
        expect(page.find('#not_altered')).to have_x_icon
        expect(page.find('#gender').text).to eq 'Female'
        expect(page.find('#special_needs')).to have_check_icon
        expect(page.find('#dogs_ok')).to have_x_icon
        expect(page.find('#cats_ok')).to have_x_icon
        expect(page.find('#kids_ok')).to have_x_icon
        expect(page.find('#catDescription').text).to match 'have a nice day'
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
        expect(page.find('#felv_fiv_test').text).to eq 'schmutz'
        expect(page.find('#flea_tick_preventative').text).to eq 'words'
        expect(page.find('#dewormer').text).to eq 'duis aute'
        expect(page.find('#coccidia_treatment').text).to eq 'excepteur sint'
        expect(page.find('#microchip').text).to eq '923456789a'
        expect(page.find('#original_name').text).to eq 'Snoop Dogg'
        expect(page.find('#fee').text).to eq '$333'
        expect(page.find('#adoption_coordinator').text).to eq adoption_coordinator.name
        expect(page.find('#sponsored_by').text).to eq 'Harry Harker'
        expect(page.find('#shelter').text).to eq shelter.name
        expect(page.find('#medical_summary').text).to eq 'medical words'
        expect(page.find('#medical_review_complete')).to have_check_icon
        expect(page.find('#behavior_summary').text).to eq 'words describing behaviour'

        expect(page.all('#galleria .galleria-stage .galleria-image img').length).to eq 1
        expect(page.all('#galleria .galleria-thumbnails-container .galleria-image img').length).to eq 2
      end
    end

    describe 'cancel while editing' do
      it "should return to the cat profile" do
        click_link('Cancel')
        cat = Cat.first
        expect(page_heading).to eq "##{cat.tracking_id} #{cat.name}"
      end
    end

    context 'user enters invalid attributes --client-side validation' do
      context 'non-integer tracking id' do
        it "should not save, and should notify user" do
          fill_in(:cat_tracking_id, with: 'new_tracking_id') # tracking id must be integer
          expect{ click_button('Submit') }.not_to change{Cat.first.tracking_id}
          expect(validation_error_message_for(:cat_tracking_id).text).to eq "Tracking id must be numeric"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_tracking_id, with: '22')
          expect(validation_error_message_for(:cat_tracking_id)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'integer tracking id with whitespace' do
        it "should save, with server stripping whitespace" do
          fill_in(:cat_tracking_id, with: '  55 ')
          expect{ click_button('Submit') }.to change{Cat.first.tracking_id}.to 55
        end
      end

      context 'blank name' do
        it "should not save and should notify user" do
          fill_in(:cat_name, with: '')
          expect{ click_button('Submit') }.not_to change{Cat.first.name}
          expect(validation_error_message_for(:cat_name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_name, with: 'Fido')
          expect(validation_error_message_for(:cat_name)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'whitespace name' do
        it "should not save and should notify user" do
          fill_in(:cat_name, with: '  ')
          expect{ click_button('Submit') }.not_to change{Cat.first.name}
          expect(validation_error_message_for(:cat_name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_name, with: 'Fido')
          expect(validation_error_message_for(:cat_name)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'improperly formatted craigslist ad url' do
        it "should not save and should notify user" do
          fill_in(:cat_craigslist_ad_url, with: 'www.craigslist.com/foo/bar/baz')
          expect{ click_button('Submit') }.not_to change{Cat.first.craigslist_ad_url}
          expect(validation_error_message_for(:cat_craigslist_ad_url).text).to eq "please include 'http://'"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_craigslist_ad_url, with: 'http://www.craigslist.com/foo/bar/baz')
          expect(validation_error_message_for(:cat_craigslist_ad_url)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes letters' do
        it 'should not save and should notify user' do
          fill_in(:cat_fee, with: '$88')
          expect{ click_button('Submit') }.not_to change{Cat.first.fee}
          expect(validation_error_message_for(:cat_fee).text).to eq "must be a whole number, with no letters"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:cat_fee, with: '88')
          expect(validation_error_message_for(:cat_fee)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes leading/trailing whitespace' do
        it 'should save' do
          fill_in(:cat_fee, with: ' 88 ')
          expect{ click_button('Submit') }.to change{Cat.first.fee}.to(88)
        end
      end

      context 'photo exceeds limit' do
        before do
          stub_const("Photo::PHOTO_MAX_SIZE", 1)
          visit edit_cats_manager_path(create(:cat))
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
          visit edit_cats_manager_path(create(:cat))
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

    #uniqueness of name and tracking id
    context 'user enters invalid attributes --server-side validation' do
      let!(:fido){ create(:cat, name: "Fido") }
      let!(:bruno){ create(:cat, name: "Bruno") }

      context 'when the user edits and creates duplicate name' do
        it 'should not save and should notify the user' do
          visit edit_cats_manager_path(bruno)
          fill_in(:cat_name, with: 'fido')
          expect{ click_button('Submit') }.not_to change{ bruno.name }
          expect(page_heading).to eq 'Edit Cat'
          expect(page.find('#cat_name')).to have_class 'is-invalid'
          expect(validation_error_message_for(:cat_name)).to be_visible
          expect(validation_error_message_for(:cat_name).text).to eq 'Name has already been taken'
          expect(flash_error_message).to eq "form could not be saved, see errors below"
        end
      end

      context 'when the user edits and creates duplicate tracking_id' do
        it 'should not save and should notify the user' do
          visit edit_cats_manager_path(bruno)
          fill_in(:cat_tracking_id, with: fido.tracking_id)
          expect{ click_button('Submit') }.not_to change{ bruno.tracking_id }
          expect(page_heading).to eq 'Edit Cat'
          expect(page.find('#cat_tracking_id')).to have_class 'is-invalid'
          expect(validation_error_message_for(:cat_tracking_id)).to be_visible
          expect(validation_error_message_for(:cat_tracking_id).text).to eq 'Tracking id has already been taken'
          expect(flash_error_message).to eq "form could not be saved, see errors below"
        end
      end
    end
  end
end
