require 'rails_helper'
require_relative '../helpers/dogs_list_helper'

feature 'Filter Dogs List', js: true do
  include DogsListHelper

  before do
    sign_in(active_user)
  end

  let!(:active_user) { create(:user) }
  let!(:primary_lab){create(:dog, :primary_lab, :active_dog, name: "Zeke").name.titleize }
  let!(:secondary_westie){create(:dog, :secondary_westie, :active_dog, name: "Nairobi").name.titleize }
  let!(:secondary_golden){create(:dog, :secondary_golden, :active_dog, name: "Abby").name.titleize }
  let(:all_dogs_sorted_by_id){ [["#1","Zeke", "Labrador Retriever"],
                                ["#2", "Nairobi", "West Highland Terrier"],
                                ["#3", "Abby", "Golden Retriever"] ] }

  scenario 'can filter results with breed partial match' do
    visit '/dogs'
    click_link("Manager View")
    expect(page).to have_selector('h1', text: 'Dog Manager')
    expect(dogs_list).to eq all_dogs_sorted_by_id

    search_by("Breed", "retriev")
    expect(dogs_list).to eq [["#1","Zeke", "Labrador Retriever"],
                             ["#3", "Abby", "Golden Retriever"] ]
    click_button("Search")
    expect(page.find('input#search').value).to eq 'retriev'
    expect(page.find('#search ul>li#breed')['class']).to eq 'selected'
    expect(page.find('#search_icon')).to be_visible
    expect(page).to have_selector('#filter_info_row #filter_info .message_group .group_label', text: "Search by:")
    expect(page).to have_selector('#filter_info_row #filter_info .message_group .filter_param', text: "Breed matches retriev")
    expect(page).to have_selector('#reset_message')
    page.find('#reset_message').click
    click_button("Search")
    expect(page.find('input#search').value).to be_blank
    expect(page.find('#search ul>li#breed')['class']).to eq ''
    expect(dogs_list).to eq all_dogs_sorted_by_id
  end

  scenario 'can search by breed and sort results by dog name' do
    visit '/dogs'
    click_link("Manager View")
    search_by("Breed", "retriev")
    expect(dog_names).to match_array ["Abby", "Zeke"]
    sort_by("name")
    expect(dog_names).to eq ["Abby", "Zeke"]
    #sort_by("name") # later we'll reverse the direction on second click TODO
    #expect(dog_names).to eq ["Zeke", "Abby"]
    page.find('#reset_message').click
    expect(dogs_list).to eq all_dogs_sorted_by_id
  end

end
