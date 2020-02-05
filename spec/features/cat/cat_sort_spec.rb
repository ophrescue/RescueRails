require 'rails_helper'
require_relative '../../helpers/cats_list_helper'
require_relative '../../helpers/rspec_matchers'
require_relative '../../helpers/application_helpers'

feature 'Cat sort in manager view', js: true do
  include CatsListHelper
  include ApplicationHelpers

  before do
    create_many_cats
    sign_in_as(active_user)

    visit '/cats_manager'
    expect(page_heading).to eq "Cat Manager"
  end

  let!(:active_user) { create(:user, :admin) }

  context 'no filter active' do
    scenario 'default sort' do
      expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by tracking_id' do
      expect(tracking_ids).to be_sorted(:descending)
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(cat_names).to be_sorted(:ascending)
      #sort_by('name')
      #expect(cat_names).to be_sorted(:descending)
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
      expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by tracking_id' do
      expect(tracking_ids).to be_sorted(:descending)
      # currently we don't flip the search order on second click
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(cat_names).to be_sorted(:ascending)
      # currently we don't flip the search order on second click
      #sort_by('name')
      #expect(cat_names).to be_sorted(:descending)
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

  context 'with cat breed filter active' do
    before do
      search_by('Cat Breed',"tabby")
      breeds.each do |breed|
        # breed is primary breed name and secondary breed name
        # separated by \n, regex match doesn't like newlines
        expect(breed.gsub(/\n/," ")).to match /tabby/i
      end
    end

    scenario 'default sort' do
      expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by tracking_id' do
      expect(tracking_ids).to be_sorted(:descending)
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(cat_names).to be_sorted(:ascending)
      #click_link("sort_by_name")
      #expect(cat_names).to be_sorted(:descending)
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
      cat_names.each do |name|
        expect(name).to match /trou/i
      end
    end

    scenario 'sort by tracking_id' do
      # initial sort is by search-string match
      sort_by('tracking_id')
      expect(tracking_ids).to be_sorted(:descending)
      #sort_by('tracking_id')
      #expect(tracking_ids).to be_sorted(:descending)
    end

    scenario 'sort by name' do
      sort_by('name')
      expect(cat_names).to be_sorted(:ascending)
      #sort_by('name')
      #expect(cat_names).to be_sorted(:descending)
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
