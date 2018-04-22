require 'rails_helper'

feature 'View Dogs', js: true do
  before { sign_in(active_user) }
  let!(:active_user) { create(:user) }
  let!(:primary_lab) { create(:dog, :primary_lab).name }
  let!(:secondary_golden) { create(:dog, :secondary_golden).name }
  let!(:secondary_westie) { create(:dog, :secondary_westie).name }


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
end
