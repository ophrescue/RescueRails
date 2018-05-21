require 'rails_helper'
require_relative '../helpers/dogs_list_helper'

feature 'Filter Dogs List', js: true do
  include DogsListHelper

  before do
    sign_in_as_user
  end

  let!(:primary_lab) { create(:dog, :primary_lab, :active_dog, name: "Zeke").name.titleize }
  let!(:secondary_golden) { create(:dog, :secondary_golden, :active_dog, name: "Abby").name.titleize }
  let!(:secondary_westie) { create(:dog, :secondary_westie, :active_dog, name: "Nairobi").name.titleize }

  scenario 'can filter results with breed partial match' do
    visit '/dogs'
    click_link("Manager View")
    expect(page).to have_selector('h1', text: 'Dog Manager')
    expect(page).to have_selector('tbody#dogs a', text: primary_lab)
    expect(page).to have_selector('tbody#dogs', text: 'Labrador Retriever')
    expect(page).to have_selector('tbody#dogs a', text: secondary_westie)
    expect(page).to have_selector('tbody#dogs', text: 'West Highland Terrier')
    expect(page).to have_selector('tbody#dogs a', text: secondary_golden)
    expect(page).to have_selector('tbody#dogs', text: 'Golden Retriever')
    fill_in('is_breed', with: "retriev")
    find_button(value: 'Filter').click
    expect(page).to have_selector('tbody#dogs a', text: primary_lab)
    expect(page).to have_selector('tbody#dogs', text: 'Labrador Retriever')
    expect(page).to have_selector('tbody#dogs a', text: secondary_golden)
    expect(page).to have_selector('tbody#dogs', text: 'Golden Retriever')
    expect(page).not_to have_selector('tbody#dogs a', text: secondary_westie)
    expect(page).not_to have_selector('tbody#dogs', text: 'West Highland Terrier')
    expect(page).to have_field('is_breed', with: 'retriev')
  end

  scenario 'can sort filter results by dog breed' do
    visit '/dogs'
    click_link("Manager View")
    fill_in('is_breed', with: "retriev")
    find_button(value: 'Filter').click
    expect(dog_names).to match_array ["Abby", "Zeke"]
    click_link('sort_by_name')
    expect(dog_names).to eq ["Abby", "Zeke"]
    click_link('sort_by_name')
    expect(dog_names).to eq ["Zeke", "Abby"]
  end

  scenario 'reset filter results displays all dogs' do
    visit "/dogs_manager?commit=Filter&direction=desc&is_breed=retriev&sort=name"
    expect(dog_names).to match_array ["Abby", "Zeke"]
    click_link("Reset")
    expect(dog_names).to match_array ["Abby", "Zeke", "Nairobi"]
  end
end
