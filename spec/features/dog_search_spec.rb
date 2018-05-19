require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/dogs_list_helper'

feature 'visit manager view', js: true do
  include ApplicationHelpers

  let!(:active_user) { create(:user, :admin) }

  context 'user is not signed in (issues #771)' do
    it 'should direct the user to sign in' do
      expect { visit '/dogs_manager?search=xyz&commit=Search' }.not_to raise_exception
      expect(page_heading).to eq 'Staff Sign in'
      expect(flash_notice_message).to eq 'Please sign in to access this page'
      fill_and_submit(active_user)
      expect(page_heading).to eq "Dog Manager"
    end
  end
end

feature 'search and clear search when admin is logged-in' do
  include DogsListHelper

  before do
    sign_in_with(active_user.email, active_user.password)
  end

  let!(:primary_lab) { create(:dog, name: "Abercrombie").name.titleize }
  let!(:secondary_golden) { create(:dog, name: "Abby").name.titleize }
  let!(:secondary_westie) { create(:dog, name: "Nairobi").name.titleize }
  let!(:active_user) { create(:user, :admin) }

  it 'should find dogs matching text partial' do
    visit '/dogs_manager?search=ab&commit=Search'
    expect(dog_names).to match_array ["Abercrombie", "Abby"]
  end

  it 'should show all dogs when search is cleared' do
    visit '/dogs_manager?search=ab&commit=Search'
    click_link 'Clear Search'
    expect(dog_names).to match_array ["Abercrombie", "Abby", "Nairobi"]
  end
end
