require 'rails_helper'

feature 'Campaigns', js: true do
  context 'campain contributions' do
    let!(:campaign) { create(:campaign) }

    it 'should be visible' do
      expect { visit campaign_path(campaign) }.not_to raise_exception
    end

    it 'should be donatable to' do
      visit campaign_path(campaign)
      click_link 'donate-now'
      expect(page).to have_content(campaign.title)
      click_button('donate20')

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
      visit campaign_path(campaign)
      expect(page).to have_content('Raised $25')

      sign_in_as_admin
      visit '/donations/history'
      expect(page).to have_content('Test Donor')
      expect(page).to have_content(campaign.title)
    end
  end

  context 'campaign creation' do
    include_context 'signed in event manager'

    it 'should be possible for event managers' do
      visit '/campaigns'
      click_link('Create a Campaign')
      fill_in('Title', with: 'My Title')
      fill_in('Goal', with: '500')
      attach_file('campaign[primary_photo]', Rails.root.join('lib','sample_images','event_images',"pic_#{rand(15)}.jpg") )
      fill_in('Summary', with: 'Quick Summary')
      fill_in('Description', with: 'A longer decsription.')
      click_button('Submit')
      expect(page).to have_content('New Campaign Added')
      expect(page).to have_content('My Title')
    end
  end
end
