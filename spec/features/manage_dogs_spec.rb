require 'rails_helper'

feature 'Manage Dogs', js: true do

  scenario 'View an existing dog' do
    test_dog = create(:dog)
    visit '/dogs'
    expect(page).to have_content(test_dog.name.titleize)
    click_link(test_dog.name)
    expect(page).to have_content(test_dog.name.titleize)
  end

end
