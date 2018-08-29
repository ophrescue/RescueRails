require 'rails_helper'
require 'stripe_mock'

feature 'Donations' do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  scenario "One time Donation", js: true do
    visit '/donations/new'
    expect(page).to have_content('Save a life')
    click_button('donate25')
    select('One Time', from: 'donationFrequency')
    fill_in('donation_name', with: 'Test Donor')
    fill_in('donation_email', with: 'fake@ophrescue.org')
    click_button('donateButton')
    stripe_card_number = '4242424242424242'
    within_frame 'stripe_checkout_app' do
      find_field('Card number').send_keys(stripe_card_number)
      find_field('MM / YY').send_keys "01#{DateTime.now.year + 1}"
      find_field('CVC').send_keys '123'
      find_field('ZIP Code').send_keys '12345'
      find('button[type="submit"]').click
    end
    sleep(5)
    expect(page).to have_content('Thank You')
  end
end
