require 'rails_helper'

feature 'Filter Dogs List', js: true do
  before do
    sign_in(active_user)
  end

  let!(:active_user) { create(:user) }
  let!(:primary_lab) { create(:dog, :primary_lab, name: "Zeke").name.titleize }
  let!(:secondary_golden) { create(:dog, :secondary_golden, name: "Abby").name.titleize }
  let!(:secondary_westie) { create(:dog, :secondary_westie, name: "Nairobi").name.titleize }


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

  scenario 'can sort filter results by dog name' do
    visit '/dogs'
    click_link("Manager View")
    fill_in('is_breed', with: "retriev")
    find_button(value: 'Filter').click
    expect(page.all("#dogs .name").map(&:text)).to match_array ["Abby", "Zeke"]
    click_link('sort_by_name')
    expect(page.all("#dogs .name").map(&:text)).to eq ["Abby", "Zeke"]
    click_link('sort_by_name')
    expect(page.all("#dogs .name").map(&:text)).to eq ["Zeke", "Abby"]
  end
end
