require 'rails_helper'

feature 'Attach an agreement to a user', js: true do
  let!(:admin) {create(:user, :admin)}
  let!(:user) {create(:user)}

  scenario 'Admin attaches a foster agreement to a user' do
    sign_in(admin)

    visit '/users'
    expect(page).to have_content('Staff Directory')
    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('No Agreement on File')
    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')
    page.attach_file('user_agreement_attributes_attachment','public/docs/blue-ridge-bloodbank.pdf')
    click_button('Update / Verify')
    expect(page).to have_content(user.name)
    expect(page).to have_content('blue-ridge-bloodbank.pdf')

  end
end
