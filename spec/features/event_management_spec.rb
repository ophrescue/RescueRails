require 'rails_helper'
require 'webmock/rspec'

feature 'Manage Events', js: true do
  let!(:admin) { create(:user, :admin) }

  scenario 'Post and View an Event' do
    sign_in(admin)
    visit root_path
    expect(page).to have_content('Events')
    click_link 'Events'
    expect(page).to have_content('Add an Event')
    click_link 'Add an Event'
    expect(page).to have_selector('label', text: 'Title')
    expect(page).to have_selector('label', text: 'Date')

    test_event = build(:event, :in_the_future)
    fill_in('event_title', with: test_event.title)
    fill_in('event_event_date', with: test_event.event_date)
    fill_in('event_start_time', with: test_event.start_time)
    fill_in('event_end_time', with: test_event.end_time)
    fill_in('event_location_name', with: test_event.location_name)
    fill_in('event_location_url', with: test_event.location_url)
    fill_in('event_facebook_url', with: test_event.facebook_url)
    fill_in('event_address', with: test_event.address)
    fill_in('event_description', with: test_event.description)
    click_button('Submit')

    expect(page).to have_content(test_event.title)
    expect(page.find('.google_map_link')['href']).to eq "https://maps.google.com/?q=40.7143528%2C-74.0059731"
    expect(page.find('.google_map_link>img')['src']).to eq "https://maps.google.com/maps/api/staticmap?size=250x100&zoom=12&sensor=false&zoom=16&markers=40.7143528%2C-74.0059731"
  end

end
