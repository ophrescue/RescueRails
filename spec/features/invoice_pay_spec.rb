require 'rails_helper'
require 'stripe_mock'

feature 'Invoices' do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before do
    raise "Stripe test requires environment variables STRIPE_PUBLISHABLE_KEY and STRIPE_SECRET_KEY to be configured" if ENV['STRIPE_PUBLISHABLE_KEY'].nil? or ENV['STRIPE_SECRET_KEY'].nil?
    StripeMock.start
  end

  after { StripeMock.stop }

  describe "Pay Dog Adoption Invoice with no donation", js: true do
    let(:adopter) { create(:adopter) }
    let(:dog) { create(:dog) }
    let(:adoption) { create(:adoption, adopter_id: adopter.id, dog_id: dog.id )}
    let!(:invoice) { create(:invoice_unpaid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }

    it 'should be payable' do
      visit invoice_path(invoice)
      expect(page).to have_content(adopter.name)
      expect(page).to have_content(dog.name)
      click_button('Make Payment')
      stripe_card_number = '4242424242424242'
      within_frame 'stripe_checkout_app' do
        find_field('Card number').send_keys(stripe_card_number)
        find_field('MM / YY').send_keys "01#{Time.zone.now.year + 1}"
        find_field('CVC').send_keys '123'
        find_field('ZIP Code').send_keys '12345'
        find('button[type="submit"]').click
      end
      sleep(5)
      expect(page).to have_content('was paid in full')

      sign_in_as_admin
      visit invoices_path
      expect(page).to have_content(adopter.name)
    end
  end

  describe "Pay Cat Adoption Invoice with a donation", js: true do
    let(:adopter) { create(:adopter) }
    let(:cat) { create(:cat) }
    let(:cat_adoption) { create(:cat_adoption, adopter_id: adopter.id, cat_id: cat.id )}
    let!(:cat_invoice) { create(:invoice_unpaid, invoiceable_id: cat_adoption.id, invoiceable_type: 'CatAdoption') }
    it 'should be payable' do
      visit invoice_path(cat_invoice)
      expect(page).to have_content(adopter.name)
      expect(page).to have_content(cat.name)
      fill_in('invoice_donation', with: '50')
      click_button('Make Payment')
      stripe_card_number = '4242424242424242'
      within_frame 'stripe_checkout_app' do
        find_field('Card number').send_keys(stripe_card_number)
        find_field('MM / YY').send_keys "01#{Time.zone.now.year + 1}"
        find_field('CVC').send_keys '123'
        find_field('ZIP Code').send_keys '12345'
        find('button[type="submit"]').click
      end
      sleep(5)
      expect(page).to have_content('was paid in full')
      expect(page).to have_content('A donation of $50.00 was included')

      sign_in_as_admin
      visit invoices_path
      expect(page).to have_content(adopter.name)
      visit '/donations/history'
      expect(page).to have_content(adopter.name)
    end
  end

end
