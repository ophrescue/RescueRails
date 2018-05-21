require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/dogs_list_helper'

feature 'visit manager view', js: true do
  include ApplicationHelpers

  context 'user is not signed in (issues #771)' do
    let(:admin) { create(:user, :admin) }

    it 'should direct the user to sign in' do
      visit '/dogs_manager?search=xyz&commit=Search'

      expect(current_path).to eq sign_in_path

      expect(page_heading).to eq 'Staff Sign in'
      expect(flash_notice_message).to eq 'Please sign in to access this page'

      # can't use sign_in_as_admin since it refreshes page losing the direct_to
      fill_and_submit(admin)

      expect(page_heading).to eq "Dog Manager"
    end
  end
end

feature 'search and clear search when admin is logged-in' do
  include DogsListHelper

  before do
    sign_in_as_admin
  end

  let!(:primary_lab) { create(:dog, name: "Abercrombie").name.titleize }
  let!(:secondary_golden) { create(:dog, name: "Abby").name.titleize }
  let!(:secondary_westie) { create(:dog, name: "Nairobi").name.titleize }

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
