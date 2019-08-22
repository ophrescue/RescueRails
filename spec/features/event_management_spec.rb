require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/client_validation_form_helpers'

feature 'Manage Events', js: true do
  include ApplicationHelpers
  include ClientValidationFormHelpers

  describe "add an event" do
    let(:test_event){ build(:event, :in_the_future) }
    let(:date_time) { "#{test_event.event_date.strftime("%A, %B %-e, %Y") } from #{test_event.start_time.strftime("%-l:%M %P") } to #{ test_event.end_time.strftime("%-l:%M %P") }" }

    before do
      sign_in_as_admin
      visit '/events'
    end

    it 'should save and render attributes' do
      expect(page).to have_content('No Upcoming Events')
      expect(page).to have_content('Add an Event')
      click_link 'Add an Event'
      expect(page).to have_selector('label', text: 'Title')
      expect(page).to have_selector('label', text: 'Date')

      fill_in('event_title', with: test_event.title)
      fill_in('event_event_date', with: test_event.event_date.strftime("%Y-%m-%d"))
      fill_in('event_start_time', with: test_event.start_time)
      fill_in('event_end_time', with: test_event.end_time)
      fill_in('event_location_name', with: test_event.location_name)
      fill_in('event_location_url', with: test_event.location_url)
      fill_in('event_facebook_url', with: test_event.facebook_url)
      fill_in('event_location_phone', with: test_event.location_phone)
      fill_in('event_address', with: test_event.address)
      fill_in('event_description', with: test_event.description)
      fill_in('event_photographer_name', with: test_event.photographer_name)
      fill_in('event_photographer_url', with: test_event.photographer_url)
      attach_file('event[photo]', Rails.root.join('lib','sample_images','event_images',"pic_#{rand(15)}.jpg") )
      click_button('Submit')

      expect(page.find('.event-title h3').text).to eq test_event.title
      expect(page.find('.event-title .date_time').text).to eq date_time
      # lat/long are default values specified in spec/support/geocoder_stubs
      expect(page.find('.google_map_link')['href']).to eq "https://maps.google.com/?q=40.7143528%2C-74.0059731"
      # <a href="/system/event_photo/31/original/20180327_210243.jpg?1529672940">
      #   <img src="/system/event_photo/31/medium/20180327_210243.jpg?1529672940">
      # </a>
      expect(page.find('.event_photo a')['href']).to match "\/system\/event_photo"
      expect(page.find('.event_photo a img')['src']).to match "\/system\/event_photo"
      expect(page.find('address .location').text).to eq test_event.location_name
      expect(page.find('address .address').text).to eq test_event.address
      expect(page.find('address .phone').text).to eq test_event.location_phone
      expect(page.find('.photographer a').text).to eq test_event.photographer_name
      expect(page.find('.photographer a')['href']).to eq test_event.photographer_url
      expect(page.find('.description').text.gsub(/\n/,'')).to eq test_event.description.gsub(/\r/,'')
    end
  end

  describe "edit an upcoming event" do
    let!(:event){ create(:event, :in_the_future, title: 'future event') }
    let(:new_upcoming_event){ build(:event, :in_the_future) }
    let!(:past_event){ create(:event, :in_the_past, title: 'past event') }

    before do
      sign_in_as_admin
      visit events_path('upcoming')
    end

    it 'should save edited attributes' do
      click_link 'edit'
      fill_in('event_title', with: new_upcoming_event.title)
      fill_in('event_event_date', with: new_upcoming_event.event_date.strftime("%Y-%m-%d"))
      fill_in('event_start_time', with: new_upcoming_event.start_time)
      fill_in('event_end_time', with: new_upcoming_event.end_time)
      fill_in('event_location_name', with: new_upcoming_event.location_name)
      fill_in('event_location_url', with: new_upcoming_event.location_url)
      fill_in('event_facebook_url', with: new_upcoming_event.facebook_url)
      fill_in('event_address', with: new_upcoming_event.address)
      fill_in('event_description', with: new_upcoming_event.description)
      check('Delete')
      click_button('Submit')
      expect(page.find('.event-title h3').text).to eq new_upcoming_event.title
      expect(page).to have_no_selector('.event_photo a')
    end

    it 'should delete an upcoming event and redirect to upcoming events' do
      count = Event.count
      accept_confirm do
        click_link('delete')
      end
      expect(flash_notice_message).to eq "Event deleted"
      expect(page.current_path).to eq scoped_events_path("upcoming")
      expect(Event.count).to eq count-1
    end

    scenario 'View past events' do
      visit scoped_events_path("past")
      expect(page_heading).to eq 'Past Events'
      expect(page).to have_selector('.event-title h3', text: past_event.title)
      expect(page).to have_no_selector('.event-title h3', text: event.title)
    end

    scenario 'View upcoming events' do
      visit scoped_events_path("upcoming")
      expect(page_heading).to eq 'Upcoming Events'
      expect(page).to have_no_selector('.event-title h3', text: past_event.title)
      expect(page).to have_selector('.event-title h3', text: event.title)
    end

    scenario 'default events view' do
      visit events_path
      expect(page_heading).to eq 'Upcoming Events'
      expect(page).to have_no_selector('.event-title h3', text: past_event.title)
      expect(page).to have_selector('.event-title h3', text: event.title)
    end

    it 'should delete a past event and redirect to past events' do
      count = Event.count
      visit scoped_events_path("past")
      accept_confirm do
        click_link('delete')
      end
      expect(flash_notice_message).to eq "Event deleted"
      expect(page.current_path).to eq scoped_events_path("past")
      expect(Event.count).to eq count-1
    end

    scenario 'apply to adopt' do
      visit scoped_events_path("upcoming")
      click_link("Apply to Adopt")
      expect(page.current_path).to eq adopt_path
    end

    scenario 'clone a past event' do
      visit scoped_events_path("past")
      click_link("create copy")
      expect(page_heading).to eq 'Create Event by Copy'

      fill_in('event_event_date', with: new_upcoming_event.event_date.strftime("%Y-%m-%d"))
      fill_in('event_start_time', with: new_upcoming_event.start_time)
      fill_in('event_end_time', with: new_upcoming_event.end_time)
      expect{ click_button('Submit') }.to change{ Event.count }.by(1)
      visit scoped_events_path("upcoming")
      expect( page.all('.event-title').count).to eq 2
      cloned_event = Event.last
      expect(cloned_event.photo.exists?).to eq true
      expect(cloned_event.attributes.values_at( "photo_file_name", "photo_content_type", "photo_file_size", "photo_updated_at")).
        not_to eq [nil, nil, nil, nil]
      expect(cloned_event.attributes.values_at( "photo_file_name", "photo_content_type", "photo_file_size")).
        to eq past_event.attributes.values_at( "photo_file_name", "photo_content_type", "photo_file_size")
    end

    scenario 'clone a past event without copying the photo' do
      visit scoped_events_path("past")
      click_link("create copy")
      expect(page_heading).to eq 'Create Event by Copy'

      fill_in('event_event_date', with: new_upcoming_event.event_date.strftime("%Y-%m-%d"))
      fill_in('event_start_time', with: new_upcoming_event.start_time)
      fill_in('event_end_time', with: new_upcoming_event.end_time)
      check('Delete')
      expect{ click_button('Submit') }.to change{ Event.count }.by(1)
      visit scoped_events_path("upcoming")
      expect( page.all('.event-title').count).to eq 2
      cloned_event = Event.last
      expect(cloned_event.attributes.values_at( :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at)).
        to eq [nil, nil, nil, nil]
    end
  end

  describe "event validation" do
    let!(:event){ create(:event, :in_the_future) }
    let(:test_event){ build(:event, :in_the_future) }

    before do
      sign_in_as_admin
      visit new_event_path
    end

    it "should show client validation error messages for required fields" do
      click_button('Submit')
      expect( validation_error_message_for(:event_title).text ).to eq "Title cannot be blank"
      expect( validation_error_message_for(:event_event_date).text ).to eq "Event date cannot be blank"
      expect( validation_error_message_for(:event_start_time).text ).to eq "Start time cannot be blank"
      expect( validation_error_message_for(:event_end_time).text ).to eq "End time cannot be blank"
      expect( validation_error_message_for(:event_location_name).text ).to eq "Location name cannot be blank"
      expect( validation_error_message_for(:event_address).text ).to eq "Address cannot be blank"
      expect( validation_error_message_for(:event_description).text ).to eq "Description cannot be blank"
    end

    it "should not show client validation error messages for blank url fields" do
      click_button('Submit')
      expect( validation_error_message_for(:event_location_url) ).not_to be_visible
      expect( validation_error_message_for(:event_facebook_url) ).not_to be_visible
    end

    it "should show client validation error messages for improperly formatted url fields" do
      fill_in('event_location_url', with: 'www.example.com')
      fill_in('event_facebook_url', with: 'www.example.com')
      click_button('Submit')
      expect( validation_error_message_for(:event_location_url).text ).to eq "Location url is improperly formatted"
      expect( validation_error_message_for(:event_facebook_url).text ).to eq "Facebook url is improperly formatted"
    end

    it "should not show client validation error messages for properly formatted url fields" do
      fill_in('event_location_url', with: 'http:www.example.com')
      fill_in('event_facebook_url', with: 'http:www.example.com')
      click_button('Submit')
      expect( validation_error_message_for(:event_location_url) ).not_to be_visible
      expect( validation_error_message_for(:event_facebook_url) ).not_to be_visible
    end

    it "should show error message when image > 5Mb is chosen" do
      attach_file('event[photo]', Rails.root.join('spec','fixtures','photo',"dog_large_pic.jpg") )
      expect( validation_error_message_for(:event_photo).text ).to eq "Photo must be a jpg or png file smaller than 5Mb"
      attach_file('event[photo]', Rails.root.join('spec','fixtures','photo',"dog_pic.jpg") )
      expect( validation_error_message_for(:event_photo)).not_to be_visible
    end

    it "should show error message when non-image attachment file is chosen" do
      attach_file('event[photo]', Rails.root.join('spec','fixtures','doc',"sample.docx") )
      expect( validation_error_message_for(:event_photo).text ).to eq "Photo must be a jpg or png file smaller than 5Mb"
      attach_file('event[photo]', Rails.root.join('spec','fixtures','photo',"dog_pic.jpg") )
      expect( validation_error_message_for(:event_photo)).not_to be_visible
    end

  end

end
