require 'rails_helper'

feature 'Attach an agreement to a user', js: true do
  let!(:admin) {create(:user, :admin)}
  let!(:user) {create(:user)}

  before :each do
    allow_any_instance_of(Attachment).to receive(:download_url).and_return('http://')
  end

  scenario 'Admin attaches a foster agreement to a user' do
    sign_in(admin)

    visit '/users'
    expect(page).to have_content('Staff Directory')
    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('No Foster Agreement on File')
    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')

    page.attach_file('user_agreement_attributes_attachment','public/docs/blue-ridge-bloodbank.pdf')
    click_button('Update / Verify')

    expect(page).to have_no_css('#confidentiality-agreement-dl')
    within('#foster-agreement-dl') do
      expect(page).to have_content 'blue-ridge-bloodbank'
    end
  end

  scenario 'Admin attaches a confidentiality agreement to a user' do
    sign_in(admin)

    visit '/users'
    expect(page).to have_content('Staff Directory')
    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('No Confidentiality Agreement on File')
    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')

    page.attach_file('user_confidentiality_agreement_attributes_attachment','public/docs/guide-to-adopting.pdf')
    click_button('Update / Verify')

    expect(page).to have_no_css('#foster-agreement-dl')
    within('#confidentiality-agreement-dl') do
      expect(page).to have_content 'guide-to-adopting'
    end

  end
end
