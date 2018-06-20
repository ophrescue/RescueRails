require 'rails_helper'
require_relative '../helpers/dogs_list_helper'
require_relative '../helpers/rspec_matchers'

feature 'Dog sort in manager view', js: true do
  include DogsListHelper

  before do
    create_many_dogs
    sign_in(active_user)
    visit '/dogs_manager'
    expect(page).to have_selector('h1', text: "Dog Manager")
  end

  let!(:active_user) { create(:user, :admin) }

  context 'no filter active' do
    scenario 'default sort' do
      expect(tracking_ids).to be_sorted(:ascending)
    end

    scenario 'sort by tracking_id' do
      expect(tracking_ids).to be_sorted(:ascending)
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(dog_names).to be_sorted(:ascending)
      #sort_by('name')
      #expect(dog_names).to be_sorted(:descending)
    end

    scenario 'sort by intake date' do
      sort_by('intake_dt')
      expect(intake_dates).to be_sorted(:ascending)
      #sort_by('intake_dt')
      #expect(intake_dates).to be_sorted(:descending)
    end

    scenario 'sort by status' do
      sort_by('status')
      expect(statuses).to be_sorted(:ascending)
      #sort_by('status')
      #expect(statuses).to be_sorted(:descending)
    end
  end

  context 'with age filter active' do
    before do
      filter_by("age","adult")
      ages.each do |age|
        expect(age).to eq 'Adult,'
      end
    end

    scenario 'default sort' do
      expect(tracking_ids).to be_sorted(:ascending)
    end

    scenario 'sort by tracking_id' do
      expect(tracking_ids).to be_sorted(:ascending)
      # currently we don't flip the search order on second click
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(dog_names).to be_sorted(:ascending)
      # currently we don't flip the search order on second click
      #sort_by('name')
      #expect(dog_names).to be_sorted(:descending)
    end

    scenario 'sort by intake date' do
      sort_by('intake_dt')
      expect(intake_dates).to be_sorted(:ascending)
      # currently we don't flip the search order on second click
      #sort_by('intake_dt')
      #expect(intake_dates).to be_sorted(:descending)
    end

    scenario 'sort by status' do
      sort_by('status')
      expect(statuses).to be_sorted(:ascending)
      # currently we don't flip the search order on second click
      #sort_by('status')
      #expect(statuses).to be_sorted(:descending)
    end
  end

  context 'with breed filter active' do
    before do
      search_by('Breed',"terr")
      breeds.each do |breed|
        # breed is primary breed name and secondary breed name
        # separated by \n, regex match doesn't like newlines
        expect(breed.gsub(/\n/," ")).to match /terrier/i
      end
    end

    scenario 'default sort' do
      expect(tracking_ids).to be_sorted(:ascending)
    end

    scenario 'sort by tracking_id' do
      expect(tracking_ids).to be_sorted(:ascending)
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(dog_names).to be_sorted(:ascending)
      #click_link("sort_by_name")
      #expect(dog_names).to be_sorted(:descending)
    end

    scenario 'sort by intake date' do
      sort_by('intake_dt')
      expect(intake_dates).to be_sorted(:ascending)
      #sort_by('intake_dt')
      #expect(intake_dates).to be_sorted(:descending)
    end

    scenario 'sort by status' do
      sort_by('status')
      expect(statuses).to be_sorted(:ascending)
      #sort_by('status')
      #expect(statuses).to be_sorted(:descending)
    end
  end

  context 'with name matching active' do
    before do
      search_by("Name", "trou")
      dog_names.each do |name|
        expect(name).to match /trou/i
      end
    end

    scenario 'sort by tracking_id' do
      # initial sort is by search-string match
      sort_by('tracking_id')
      expect(tracking_ids).to be_sorted(:ascending)
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(dog_names).to be_sorted(:ascending)
      #sort_by('name')
      #expect(dog_names).to be_sorted(:descending)
    end

    scenario 'sort by intake date' do
      sort_by('intake_dt')
      expect(intake_dates).to be_sorted(:ascending)
      #sort_by('intake_dt')
      #expect(intake_dates).to be_sorted(:descending)
    end

    scenario 'sort by status' do
      sort_by('status')
      expect(statuses).to be_sorted(:ascending)
      #sort_by('status')
      #expect(statuses).to be_sorted(:descending)
    end
  end
end
