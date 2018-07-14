require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/rspec_matchers'
require_relative '../helpers/dog_form_helpers'
require_relative '../helpers/dogs_list_helper'

feature 'add a dog', js: true do
  include DogFormHelpers
  include ApplicationHelpers

  feature 'permitted access to fields' do
    let(:active_record_attributes){ [:created_at, :updated_at, :id].map(&:to_s) }
    let(:not_editable_attributes){ [:youtube_video_url, :petfinder_ad_url, :tracking_id].map(&:to_s) }
    let(:all_database_attributes){ Dog.new.attributes.keys }
    let(:all_form_fields) { all_database_attributes - active_record_attributes - not_editable_attributes }

    before do
      sign_in(active_user)
      visit new_dogs_manager_path
    end

    context 'user not permitted to manage_medical_behavior' do
      let!(:active_user) { create(:user, :admin, medical_behavior_permission: false ) }
      let(:disallowed_fields){ ['medical_summary', 'behavior_summary'] }

      it 'should allow access to all fields except medical summary' do
        (all_form_fields - disallowed_fields).each do |field|
          expect(page.find("#dog_#{field}")).not_to be_disabled
        end
      end

      it 'should not show headings or inputs for medical summary and behavior summary' do
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

  feature "save attributes" do
    include ApplicationHelpers
    include DogsListHelper

    let!(:active_user) { create(:user, :admin) }
    let!(:primary_breed){ create(:breed, name: 'new primary breed') }
    let!(:secondary_breed){ create(:breed, name: 'new secondary breed') }
    let!(:foster){ create(:foster, name: 'Dede Doglady') }
    let!(:adoption_coordinator){ create(:adoption_coordinator) }
    let!(:shelter){ create(:shelter) }

    before do
      sign_in(active_user)
      visit new_dogs_manager_path
    end

    context 'user enters valid attributes' do
      it "should save the user-entered values" do
        fill_in(:dog_name, with: 'newname')
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

        expect(page_heading).to match 'Dog Manager'
        expect(dog_names).to include('newname')
      end
    end

    context 'user enters invalid attributes --client-side validation' do
      context 'no status selected' do
        it "should not save and should notify user" do
          fill_in(:dog_name, with: 'Fido')
          expect{ click_button('Submit') }.not_to change{Dog.count}
          expect(validation_error_message_for(:status).text).to eq "Status must be selected"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          select('adoption pending', from: 'dog_status')
          expect(validation_error_message_for(:status)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'blank name' do
        it "should not save and should notify user" do
          select('adoption pending', from: 'dog_status')
          expect{ click_button('Submit') }.not_to change{Dog.count}
          expect(validation_error_message_for(:name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_name, with: 'Fido')
          expect(validation_error_message_for(:name)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'with any of the Faker names' do
        it "should validate the name on the browser" do
          click_button('Submit')
          expect(validation_error_message_for(:name).text).to eq "Name cannot be blank"
          # here we test against just 30 names, for performance reasons
          # if any changes are made to this code it would be wise to
          # remove the .sample(30) and verify code against all thenames
          names = I18n.t('faker.dog.name').sample(30)
          names.each do |name|
            fill_in(:dog_name, with: name)
            expect(validation_error_message_for(:name)).not_to be_visible
          end
        end
      end

      context 'whitespace name' do
        it "should not save and should notify user" do
          select('adoption pending', from: 'dog_status')
          fill_in(:dog_name, with: '  ')
          expect{ click_button('Submit') }.not_to change{Dog.count}
          expect(validation_error_message_for(:name).text).to eq "Name cannot be blank"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_name, with: 'Fido')
          expect(validation_error_message_for(:name)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'name with legitimate whitespace' do
        it "should save" do
          fill_in(:dog_name, with: ' Fido Smith ')
          select('adoption pending', from: 'dog_status')
          expect{ click_button('Submit') }.to change{Dog.count}.by(1)
          expect(Dog.first.name).to eq "Fido Smith"
        end
      end

      context 'name with acceptable punctuation' do
        it "should save" do
          fill_in(:dog_name, with: ' B.B. Mc-Fido ')
          select('adoption pending', from: 'dog_status')
          expect{ click_button('Submit') }.to change{Dog.count}.by(1)
          expect(Dog.first.name).to eq "B.B. Mc-Fido"
        end
      end

      context 'improperly formatted craigslist ad url' do
        it "should not save and should notify user" do
          fill_in(:dog_name, with: 'Fido')
          select('adoption pending', from: 'dog_status')
          fill_in(:dog_craigslist_ad_url, with: 'www.craigslist.com/foo/bar/baz')
          expect{ click_button('Submit') }.not_to change{Dog.count}
          expect(validation_error_message_for(:craigslist_ad_url).text).to eq "please include 'http://'"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_craigslist_ad_url, with: 'http://www.craigslist.com/foo/bar/baz')
          expect(validation_error_message_for(:craigslist_ad_url)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes letters' do
        it 'should not save and should notify user' do
          fill_in(:dog_name, with: 'Fido')
          select('adoption pending', from: 'dog_status')
          fill_in(:dog_fee, with: '$88')
          expect{ click_button('Submit') }.not_to change{Dog.count}
          expect(validation_error_message_for(:fee).text).to eq "must be a whole number, with no letters"
          expect(submit_button_form_error_message.text).to eq "form cannot be saved due to errors"
          fill_in(:dog_fee, with: '88')
          expect(validation_error_message_for(:fee)).not_to be_visible
          expect(submit_button_form_error_message).not_to be_visible
        end
      end

      context 'adoption fee includes leading/trailing whitespace' do
        it 'should save' do
          fill_in(:dog_name, with: 'Fido')
          fill_in(:dog_fee, with: ' 88 ')
          select('adoption pending', from: 'dog_status')
          click_button('Submit')
          expect( Dog.first.fee ).to eq 88
        end
      end

    end

    #uniqueness of name validated on server
    context 'user enters invalid attributes --server-side validation' do
      let!(:fido){ create(:dog, name: "Fido") }

      context 'when the user adds a dog with a duplicate name' do
        it 'should not save and should notify the user' do
          visit new_dogs_manager_path
          fill_in(:dog_name, with: 'fido')
          select('adoption pending', from: 'dog_status')
          expect{ click_button('Submit') }.not_to change{ Dog.count }
          expect(page_heading).to eq 'Add a New Dog'
          expect(page.find('#dog_name')).to have_class 'is-invalid'
          expect(validation_error_message_for(:name)).to be_visible
          expect(validation_error_message_for(:name).text).to eq 'Name has already been taken'
          expect(flash_error_message).to eq "form could not be saved, see errors below"
        end
      end

    end
  end
end
