require 'rails_helper'
require 'stripe_mock'

feature 'Donations' do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before do
    raise "Stripe test requires environment variables STRIPE_PUBLISHABLE_KEY and STRIPE_SECRET_KEY to be configured" if ENV['STRIPE_PUBLISHABLE_KEY'].nil? or ENV['STRIPE_SECRET_KEY'].nil?
    StripeMock.start
  end

  after { StripeMock.stop }

  scenario "One time Donation", js: true do
    visit '/donations/new'
    expect(page).to have_content('Save a life')
    click_button('donate25')

    choose('donation_frequency_once')
    check 'honorToggle'
    choose 'donation_memory_honor_type_in_honor_of'
    fill_in('donation_memory_honor_name', with: 'Miss Honoree')

    check 'notifyToggle'
    fill_in('donation_notify_name', with: 'Mr. Person To Notify')
    fill_in('donation_notify_email', with: 'fake123notification@ophrescue.org')
    fill_in('donation_notify_message', with: 'This is a donation message')

    fill_in('donation_name', with: 'Test Donor')
    fill_in('donation_email', with: 'fake@ophrescue.org')

    click_button('donateButton')
    stripe_card_number = '4242424242424242'
    within_frame 'stripe_checkout_app' do
      find_field('Card number').send_keys(stripe_card_number)
      find_field('MM / YY').send_keys "01#{Time.zone.now.year + 1}"
      find_field('CVC').send_keys '123'
      find_field('ZIP Code').send_keys '12345'
      find('button[type="submit"]').click
    end
    sleep(5)
    expect(page).to have_content('Thank You')

    sign_in_as_admin
    visit '/donations/history'
    expect(page).to have_content('Test Donor')
  end

  scenario "Verify Pagination" do
    32.times do
      FactoryBot.create(:donation)
    end
    sign_in_as_admin
    visit '/donations/history'
    expect(page).to have_selector :css, 'nav.pagination'
    expect(page.all('table tbody tr').size).to eq 30
  end
end
