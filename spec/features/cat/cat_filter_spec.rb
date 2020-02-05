require 'rails_helper'
require_relative '../../helpers/cats_list_helper'

feature 'Filter Cats List', js: true do
  include CatsListHelper

  describe "filter by breed" do
    before do
      sign_in_as_user
    end

    let!(:zeke){ create(:cat, :no_flags, :primary_shorthair, :active_cat, name: "Zeke") }
    let!(:nairobi){ create(:cat, :no_flags, :secondary_persian, :active_cat, name: "Nairobi") }
    let!(:abby){ create(:cat, :no_flags, :secondary_shorthair, :active_cat, name: "Abby") }
    let(:all_cats_sorted_by_id){ [["##{zeke.tracking_id}","Zeke", "American Shorthair,"],
                                  ["##{nairobi.tracking_id}", "Nairobi", "Persian,"],
                                  ["##{abby.tracking_id}", "Abby", "American Shorthair,"] ] }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    scenario 'with breed partial match' do
      visit cats_manager_index_path
      expect(page).to have_selector('h1', text: 'Cat Manager')
      expect(cats_list).to eq all_cats_sorted_by_id.reverse

      search_by("Cat Breed", "shorthai")
      expect(cats_list).to eq [ ["##{abby.tracking_id}", "Abby", "American Shorthair,"],
                                ["##{zeke.tracking_id}","Zeke", "American Shorthair,"] ]
      click_button("Search")
      # search parameters for the search currently active are shown in the search dropdown
      expect(page.find('input#search').value).to eq 'shorthai'
      expect(page.find('#search_field_index ul>li._cat_breed input', visible: false)).to be_checked # it's not visible b/c we hide it in order to make custom radio button
      expect(page.find('#search_icon')).to be_visible

      # all current filter params are shown
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'shorthai'")
      expect(page).to have_selector('#reset_message')

      # close and open the search dropdown... search params are still shown
      click_button("Search") # close
      click_button("Search") # open
      expect(page.find('input#search').value).to eq 'shorthai'
      expect(page.find('#search_field_index ul>li._cat_breed input', visible: false)).to be_checked # it's not visible b/c we hide it in order to make custom radio button
      expect(page.find('#search_icon')).to be_visible

      page.find('#reset_message').click
      click_button("Search")
      expect(page.find('input#search').value).to be_blank
      expect(page.find('#search_field_index ul>li._cat_breed input', visible: false)).not_to be_checked
      expect(cats_list).to eq all_cats_sorted_by_id.reverse
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(page).to have_no_selector(group_label, text: "Search by:")
      expect(page).to have_no_selector(filter_params, text: "Breed matches 'shorthai'")
      expect(page).to have_no_selector('#reset_message')
    end

    scenario 'and sort results by cat name' do
      visit cats_manager_index_path
      expect(page).to have_selector('h1', text: 'Cat Manager')
      search_by("Cat Breed", "shorthai")
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'shorthai'")
      expect(cat_names).to match_array ["Abby", "Zeke"]
      sort_by("name")
      expect(cat_names).to eq ["Abby", "Zeke"]
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Name")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'shorthai'")
      #sort_by("name") # later we'll reverse the direction on second click TODO
      #expect(cat_names).to eq ["Zeke", "Abby"]
      sort_by("status")
      expect(cat_names).to match_array ["Abby", "Zeke"]
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Status")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'shorthai'")
      sort_by("intake_dt")
      expect(cat_names).to match_array ["Abby", "Zeke"]
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Intake date")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'shorthai'")
      page.find('#reset_message').click
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(cats_list).to eq all_cats_sorted_by_id.reverse
    end

    scenario 'shows error message if user forgets to select search attribute' do
      visit cats_manager_index_path
      expect(page).to have_selector('h1', text: 'Cat Manager')
      click_button("Search")
      expect(page).to have_selector('#search-dropdown-heading')
      page.find('input#search').set("shorthai")
      page.find('#search_icon').click
      expect(page).to have_no_selector('#search-dropdown-heading')
      expect(page).to have_selector('#search-error-message', text: 'Please select a field to search in')
      select_search_by('Cat Breed')
      expect(page).to have_no_selector('#search-error-message')
      expect(page).to have_no_selector('#search-dropdown-heading')
    end

    scenario 'search after being reminded to select search attribute' do
      visit cats_manager_index_path
      expect(page).to have_selector('h1', text: 'Cat Manager')
      click_button("Search")
      page.find('input#search').set("shorthai")
      page.find('#search_icon').click
      select_search_by('Cat Breed')
      page.find('#search_icon').click
      expect(cat_names).to match_array ["Zeke", "Abby"]
    end

    scenario 'reset search field' do
      visit cats_manager_index_path
      expect(page).to have_selector('h1', text: 'Cat Manager')
      click_button("Search")
      page.find('input#search').set("shortha")
      select_search_by('Cat Breed')
      page.find('#search_reset_button').click
      expect(page.find('input#search').value).to be_blank
      expect(page.find('#search_reset_button', visible: false)).not_to be_visible
      expect(page.find('#search_button', visible: false)).not_to be_visible
      expect(page.all('#search_field_index input[type="radio"]', visible: false).map(&:checked?).any?).to eq false
    end

    scenario 'reset search params on dropdown close without search' do
      visit cats_manager_index_path
      expect(page).to have_selector('h1', text: 'Cat Manager')
      click_button("Search")
      select_search_by('Cat Breed')
      page.find('input#search').set("shorthai")
      click_button("Search") # close
      click_button("Search") # open again
      expect(page.find('input#search').value).to be_blank
      expect(page.all('#search_field_index input[type="radio"]', visible: false).map(&:checked?).any?).to eq false
    end
  end

  describe "filter by flags" do
    before do
      sign_in_as_user
    end

    let!(:high_priority){ create(:cat, :no_flags, is_high_priority: true, name: 'High Priority') }
    let!(:medical_need){ create(:cat, :no_flags, has_medical_need: true, name: "Medical Need") }
    let!(:special_needs){ create(:cat, :no_flags, is_special_needs: true, name: "Special Needs") }
    let!(:medical_review_needed){ create(:cat, :no_flags, medical_review_complete: false, name: "Medical Review Needed") }
    let!(:behavior_problems){ create(:cat, :no_flags, has_behavior_problem: true, name: "Behavior Problems") }
    let!(:foster_needed){ create(:cat, :no_flags, status: 'adoptable', needs_foster: true, name: 'Foster Needed') }
    let!(:spay_neuter_needed){ create(:cat, :no_flags, is_altered: false, name: 'Spay Neuter Needed') }
    let!(:no_cats){ create(:cat, :no_flags, no_cats: true, name: 'No Cats') }
    let!(:no_dogs){ create(:cat, :no_flags, no_dogs: true, name: 'No Dogs') }
    let!(:no_kids){ create(:cat, :no_flags, no_kids: true, name: 'No Kids') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Cat::FILTER_FLAGS.as_options.each do |key,text|
      scenario "can filter by '#{key}' flag attribute" do
        visit cats_manager_index_path
        expect(page).to have_selector('h1', text: 'Cat Manager')
        filter_by("flags", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Flags:")
        expect(page).to have_selector(filter_params, text: text)
        expect(page).to have_selector('#reset_message')
        expect(cat_names).to eq [text]
        expect(cat_names.count).to eq 1
      end
    end
  end

  describe "filter by size" do
    before do
      sign_in_as_user
    end

    #SIZES = ['small', 'medium', 'large', 'extra large']
    let!(:small) { create(:cat, size: 'small', name: 'Small Cat') }
    let!(:medium) { create(:cat, size: 'medium', name: 'Medium Cat') }
    let!(:large) { create(:cat, size: 'large', name: 'Large Cat') }
    let!(:extra_large) { create(:cat, size: 'extra large', name: 'Extra Large Cat') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Cat::SIZES.as_options.each do |key,text|
      scenario "can filter by '#{text}' size attribute" do
        visit cats_manager_index_path
        expect(page).to have_selector('h1', text: 'Cat Manager')
        filter_by("size", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Size:")
        expect(page).to have_selector(filter_params, text: text )
        expect(page).to have_selector('#reset_message')
        expect(cat_names).to eq ["#{text.titleize} Cat"]
        expect(cat_names.count).to eq 1
      end
    end
  end

  describe "filter by status" do
    before do
      sign_in_as_user
    end

    #STATUSES = ['adoptable', 'adopted', 'adoption pending', 'trial adoption',
    #            'on hold', 'not available', 'return pending', 'coming soon', 'completed']
    let!(:adoptable) { create(:cat, status: 'adoptable', name: 'Adoptable Cat') }
    let!(:adopted) { create(:cat, status: 'adopted', name: 'Adopted Cat') }
    let!(:adoption_pending) { create(:cat, status: 'adoption pending', name: 'Adoption Pending Cat') }
    let!(:trial_adoption) { create(:cat, status: 'trial adoption', name: 'Trial Adoption Cat') }
    let!(:on_hold) { create(:cat, status: 'on hold', name: 'On Hold Cat') }
    let!(:not_available) { create(:cat, status: 'not available', name: 'Not Available Cat') }
    let!(:return_pending) { create(:cat, status: 'return pending', name: 'Return Pending Cat') }
    let!(:coming_soon) { create(:cat, status: 'coming soon', name: 'Coming Soon Cat') }
    let!(:completed) { create(:cat, status: 'completed', name: 'Completed Cat') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Cat::STATUSES.as_options.each do |key,text|
      scenario "can filter by '#{text}' status attribute" do
        visit cats_manager_index_path
        expect(page).to have_selector('h1', text: 'Cat Manager')
        filter_by("status", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Status:")
        expect(page).to have_selector(filter_params, text: text )
        expect(page).to have_selector('#reset_message')
        expect(cat_names).to eq ["#{text.titleize} Cat"]
        expect(cat_names.count).to eq 1
      end
    end
  end

  describe "filter by age" do
    before do
      sign_in_as_user
    end

    #  AGES = %w[baby young adult senior]
    let!(:baby) { create(:cat, age: 'baby', name: 'Baby Cat') }
    let!(:young) { create(:cat, age: 'young', name: 'Young Cat') }
    let!(:adult) { create(:cat, age: 'adult', name: 'Adult Cat') }
    let!(:senior) { create(:cat, age: 'senior', name: 'Senior Cat') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Cat::AGES.as_options.each do |key,text|
      scenario "can filter by '#{text}' age attribute" do
        visit cats_manager_index_path
        expect(page).to have_selector('h1', text: 'Cat Manager')
        filter_by("age", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Age:")
        expect(page).to have_selector(filter_params, text: text )
        expect(page).to have_selector('#reset_message')
        expect(cat_names).to eq ["#{text.titleize} Cat"]
        expect(cat_names.count).to eq 1
      end
    end
  end
end
