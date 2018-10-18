require 'rails_helper'
require_relative '../../helpers/dogs_list_helper'

feature 'Filter Dogs List', js: true do
  include DogsListHelper

  describe "filter by breed" do
    before do
      sign_in_as_user
    end

    let!(:zeke){create(:dog, :no_flags, :primary_lab, :active_dog, name: "Zeke") }
    let!(:nairobi){create(:dog, :no_flags, :secondary_westie, :active_dog, name: "Nairobi") }
    let!(:abby){create(:dog, :no_flags, :secondary_golden, :active_dog, name: "Abby") }
    let(:all_dogs_sorted_by_id){ [["##{zeke.tracking_id}","Zeke", "Labrador Retriever,"],
                                  ["##{nairobi.tracking_id}", "Nairobi", "West Highland Terrier,"],
                                  ["##{abby.tracking_id}", "Abby", "Golden Retriever,"] ] }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    scenario 'with breed partial match' do
      visit dogs_manager_index_path
      expect(page).to have_selector('h1', text: 'Dog Manager')
      expect(dogs_list).to eq all_dogs_sorted_by_id.reverse

      search_by("Breed", "retriev")
      expect(dogs_list).to eq [ ["##{abby.tracking_id}", "Abby", "Golden Retriever,"],
                                ["##{zeke.tracking_id}","Zeke", "Labrador Retriever,"] ]
      click_button("Search")
      # search parameters for the search currently active are shown in the search dropdown
      expect(page.find('input#search').value).to eq 'retriev'
      expect(page.find('#search_field_index ul>li._breed input', visible: false)).to be_checked # it's not visible b/c we hide it in order to make custom radio button
      expect(page.find('#search_icon')).to be_visible

      # all current filter params are shown
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'retriev'")
      expect(page).to have_selector('#reset_message')

      # close and open the search dropdown... search params are still shown
      click_button("Search") # close
      click_button("Search") # open
      expect(page.find('input#search').value).to eq 'retriev'
      expect(page.find('#search_field_index ul>li._breed input', visible: false)).to be_checked # it's not visible b/c we hide it in order to make custom radio button
      expect(page.find('#search_icon')).to be_visible

      page.find('#reset_message').click
      click_button("Search")
      expect(page.find('input#search').value).to be_blank
      expect(page.find('#search_field_index ul>li._breed input', visible: false)).not_to be_checked
      expect(dogs_list).to eq all_dogs_sorted_by_id.reverse
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(page).to have_no_selector(group_label, text: "Search by:")
      expect(page).to have_no_selector(filter_params, text: "Breed matches 'retriev'")
      expect(page).to have_no_selector('#reset_message')
    end

    scenario 'and sort results by dog name' do
      visit dogs_manager_index_path
      search_by("Breed", "retriev")
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'retriev'")
      expect(dog_names).to match_array ["Abby", "Zeke"]
      sort_by("name")
      expect(dog_names).to eq ["Abby", "Zeke"]
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Name")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'retriev'")
      #sort_by("name") # later we'll reverse the direction on second click TODO
      #expect(dog_names).to eq ["Zeke", "Abby"]
      sort_by("status")
      expect(dog_names).to match_array ["Abby", "Zeke"]
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Status")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'retriev'")
      sort_by("intake_dt")
      expect(dog_names).to match_array ["Abby", "Zeke"]
      expect(page).to have_selector(group_label, text: "Sort:")
      expect(page).to have_selector(filter_params, text: "Intake date")
      expect(page).to have_selector(group_label, text: "Search by:")
      expect(page).to have_selector(filter_params, text: "Breed matches 'retriev'")
      page.find('#reset_message').click
      expect(page).to have_selector(filter_params, text: "Tracking ID")
      expect(dogs_list).to eq all_dogs_sorted_by_id.reverse
    end

    scenario 'shows error message if user forgets to select search attribute' do
      visit dogs_manager_index_path
      click_button("Search")
      expect(page).to have_selector('#search-dropdown-heading')
      page.find('input#search').set("retr")
      page.find('#search_icon').click
      expect(page).to have_no_selector('#search-dropdown-heading')
      expect(page).to have_selector('#search-error-message', text: 'Please select a field to search in')
      select_search_by('Breed')
      expect(page).to have_no_selector('#search-error-message')
      expect(page).to have_no_selector('#search-dropdown-heading')
    end

    scenario 'search after being reminded to select search attribute' do
      visit dogs_manager_index_path
      click_button("Search")
      page.find('input#search').set("retr")
      page.find('#search_icon').click
      select_search_by('Breed')
      page.find('#search_icon').click
      expect(dog_names).to match_array ["Zeke", "Abby"]
    end

    scenario 'reset search field' do
      visit dogs_manager_index_path
      click_button("Search")
      page.find('input#search').set("retr")
      select_search_by('Breed')
      page.find('#search_reset_button').click
      expect(page.find('input#search').value).to be_blank
      expect(page.find('#search_reset_button', visible: false)).not_to be_visible
      expect(page.find('#search_button', visible: false)).not_to be_visible
      expect(page.all('#search_field_index input[type="radio"]', visible: false).map(&:checked?).any?).to eq false
    end

    scenario 'reset search params on dropdown close without search' do
      visit dogs_manager_index_path
      click_button("Search")
      select_search_by('Breed')
      page.find('input#search').set("retr")
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

    let!(:high_priority){ create(:dog, :no_flags, is_high_priority: true, name: 'High Priority') }
    let!(:medical_need){ create(:dog, :no_flags, has_medical_need: true, name: "Medical Need") }
    let!(:special_needs){ create(:dog, :no_flags, is_special_needs: true, name: "Special Needs") }
    let!(:medical_review_needed){ create(:dog, :no_flags, medical_review_complete: false, name: "Medical Review Needed") }
    let!(:behavior_problems){ create(:dog, :no_flags, has_behavior_problem: true, name: "Behavior Problems") }
    let!(:foster_needed){ create(:dog, :no_flags, status: 'adoptable', needs_foster: true, name: 'Foster Needed') }
    let!(:spay_neuter_needed){ create(:dog, :no_flags, is_altered: false, name: 'Spay Neuter Needed') }
    let!(:no_cats){ create(:dog, :no_flags, no_cats: true, name: 'No Cats') }
    let!(:no_dogs){ create(:dog, :no_flags, no_dogs: true, name: 'No Dogs') }
    let!(:no_kids){ create(:dog, :no_flags, no_kids: true, name: 'No Kids') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Dog::FILTER_FLAGS.as_options.each do |key,text|
        scenario "can filter by '#{key}' flag attribute" do
          visit dogs_manager_index_path
          filter_by("flags", key)
          expect(page).to have_selector(group_label, text: "Sort:")
          expect(page).to have_selector(filter_params, text: "Tracking ID")
          expect(page).to have_selector(group_label, text: "Flags:")
          expect(page).to have_selector(filter_params, text: text)
          expect(page).to have_selector('#reset_message')
          expect(dog_names).to eq [text]
          expect(dog_names.count).to eq 1
        end
      end
  end

  describe "filter by size" do
    before do
      sign_in_as_user
    end

    #SIZES = ['small', 'medium', 'large', 'extra large']
    let!(:small) { create(:dog, size: 'small', name: 'Small Dog') }
    let!(:medium) { create(:dog, size: 'medium', name: 'Medium Dog') }
    let!(:large) { create(:dog, size: 'large', name: 'Large Dog') }
    let!(:extra_large) { create(:dog, size: 'extra large', name: 'Extra Large Dog') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Dog::SIZES.as_options.each do |key,text|
      scenario "can filter by '#{text}' size attribute" do
        visit dogs_manager_index_path

        filter_by("size", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Size:")
        expect(page).to have_selector(filter_params, text: text )
        expect(page).to have_selector('#reset_message')
        expect(dog_names).to eq ["#{text.titleize} Dog"]
        expect(dog_names.count).to eq 1
      end
    end
  end

  describe "filter by status" do
    before do
      sign_in_as_user
    end

    #STATUSES = ['adoptable', 'adopted', 'adoption pending', 'trial adoption',
    #            'on hold', 'not available', 'return pending', 'coming soon', 'completed']
    let!(:adoptable) { create(:dog, status: 'adoptable', name: 'Adoptable Dog') }
    let!(:adopted) { create(:dog, status: 'adopted', name: 'Adopted Dog') }
    let!(:adoption_pending) { create(:dog, status: 'adoption pending', name: 'Adoption Pending Dog') }
    let!(:trial_adoption) { create(:dog, status: 'trial adoption', name: 'Trial Adoption Dog') }
    let!(:on_hold) { create(:dog, status: 'on hold', name: 'On Hold Dog') }
    let!(:not_available) { create(:dog, status: 'not available', name: 'Not Available Dog') }
    let!(:return_pending) { create(:dog, status: 'return pending', name: 'Return Pending Dog') }
    let!(:coming_soon) { create(:dog, status: 'coming soon', name: 'Coming Soon Dog') }
    let!(:completed) { create(:dog, status: 'completed', name: 'Completed Dog') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Dog::STATUSES.as_options.each do |key,text|
      scenario "can filter by '#{text}' status attribute" do
        visit dogs_manager_index_path

        filter_by("status", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Status:")
        expect(page).to have_selector(filter_params, text: text )
        expect(page).to have_selector('#reset_message')
        expect(dog_names).to eq ["#{text.titleize} Dog"]
        expect(dog_names.count).to eq 1
      end
    end
  end

  describe "filter by age" do
    before do
      sign_in_as_user
    end

    #  AGES = %w[baby young adult senior]
    let!(:baby) { create(:dog, age: 'baby', name: 'Baby Dog') }
    let!(:young) { create(:dog, age: 'young', name: 'Young Dog') }
    let!(:adult) { create(:dog, age: 'adult', name: 'Adult Dog') }
    let!(:senior) { create(:dog, age: 'senior', name: 'Senior Dog') }
    let(:group_label) { '#filter_info_row #filter_info .message_group .group_label' }
    let(:filter_params) { '#filter_info_row #filter_info .message_group .filter_params' }

    Dog::AGES.as_options.each do |key,text|
      scenario "can filter by '#{text}' age attribute" do
        visit dogs_manager_index_path

        filter_by("age", key)
        expect(page).to have_selector(group_label, text: "Sort:")
        expect(page).to have_selector(filter_params, text: "Tracking ID")
        expect(page).to have_selector(group_label, text: "Age:")
        expect(page).to have_selector(filter_params, text: text )
        expect(page).to have_selector('#reset_message')
        expect(dog_names).to eq ["#{text.titleize} Dog"]
        expect(dog_names.count).to eq 1
      end
    end
  end
end
