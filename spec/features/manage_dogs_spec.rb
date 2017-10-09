require 'rails_helper'

feature 'View Dogs', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:test_foster) { create(:user) }
  let!(:test_dog) { create(:dog_with_photo_and_attachment, foster_id: test_foster.id) }

  scenario 'View a dog from the public view' do
    visit '/dogs'
    expect(page).to have_content(test_dog.name.titleize)
    click_link(test_dog.name)
    expect(page).to have_content(test_dog.name.titleize)
  end

  scenario 'View a dog from manager view' do
    sign_in(admin)
    visit '/dogs'
    click_link("Manager View")
    expect(page).to have_content(test_dog.name.titleize)
    click_link(test_dog.name)
    expect(page).to have_content(test_dog.name.titleize)
  end
end
