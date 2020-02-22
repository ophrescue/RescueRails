require 'rails_helper'
require_relative '../../helpers/application_helpers'
require_relative '../../helpers/cats_list_helper'

feature 'visit manager view', js: true do
  include ApplicationHelpers

  let!(:active_user) { create(:user, :admin) }

  context 'user is not signed in (issues #771)' do
    it 'should direct the user to sign in' do
      expect { visit '/cats_manager?search=xyz' }.not_to raise_exception
      expect(page_heading).to eq 'Staff Sign in'
      expect(flash_notice_alert_message).to eq "Please sign in to continue."

      fill_and_submit(active_user)
      expect(page_heading).to eq "Cat Manager"
    end
  end
end

feature 'search and clear search when admin is logged-in', js: true do
  include CatsListHelper

  before do
    sign_in_as_admin
  end

  let!(:primary_lab) { create(:cat, name: "Abercrombie").name.titleize }
  let!(:secondary_golden) { create(:cat, name: "Abby").name.titleize }
  let!(:secondary_westie) { create(:cat, name: "Nairobi").name.titleize }
  let!(:active_user) { create(:user, :admin) }
  let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

  it 'should find dogs matching text partial' do
    visit cats_manager_index_path(filter_params: { search: 'ab', search_field_index: 'name' })
    expect(cat_names).to match_array ["Abercrombie", "Abby"]
  end

  it 'should show all dogs when search is cleared' do
    visit cats_manager_index_path(filter_params: { search: 'ab', search_field_index: 'name' })
    click_link 'reset_message'
    sleep(2)
    expect(page).to have_selector(filter_params, text: "Tracking ID")
    expect(cat_names).to match_array ["Abercrombie", "Abby", "Nairobi"]
  end
end
