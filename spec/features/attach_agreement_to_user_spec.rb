require 'rails_helper'

feature 'Attach an agreement to a user', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }

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

    page.attach_file('user_agreement_attributes_attachment', 'public/docs/spay-neuter-agreement.pdf')
    click_button('Update / Verify')

    expect(page).to have_no_css('#confidentiality-agreement-dl')
    within('#foster-agreement-dl') do
      expect(page).to have_content 'spay-neuter-agreement'
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

    page.attach_file('user_confidentiality_agreement_attributes_attachment', 'public/docs/what-to-buy-ahead-of-time.pdf')
    click_button('Update / Verify')

    expect(page).to have_no_css('#foster-agreement-dl')
    within('#confidentiality-agreement-dl') do
      expect(page).to have_content 'what-to-buy-ahead-of-time'
    end

  end

  scenario 'Admin attaches a code of conduct agreement to a user' do
    sign_in(admin)

    visit '/users'
    expect(page).to have_content('Staff Directory')
    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('No Code of Conduct Agreement on File')
    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')

    page.attach_file('user_code_of_conduct_agreement_attributes_attachment', 'public/docs/new-puppy-info.pdf')
    click_button('Update / Verify')

    expect(page).to have_no_css('#foster-agreement-dl')
    expect(page).to have_no_css('#confidentiality-agreement-dl')
    within('#code-of-conduct-agreement-dl') do
      expect(page).to have_content 'new-puppy-info'
    end

  end
end
