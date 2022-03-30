require 'rails_helper'

feature 'Attach an agreement to a user', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }

  before :each do
    allow_any_instance_of(Attachment).to receive(:download_url).and_return('http://')
  end

  scenario 'User attaches insurance training agreement to their profile' do
    sign_in_as(user)

    visit '/users'
    expect(page).to have_content('Staff Directory')

    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('Insurance Training Incomplete')

    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')

    page.attach_file('user_insurance_training_agreement_attributes_attachment', Rails.root.join("public", "docs", "Puppy-rescue-letter.pdf"))
    click_button('Update / Verify')

    expect(page).to have_no_css('#confidentiality-agreement-dl')
    expect(page).to have_no_css('#foster-agreement-dl')
    within('#insurance-training-agreement-dl') do
      expect(page).to have_content 'Puppy-rescue-letter'
    end
  end

  scenario 'Admin attaches a foster agreement to a user', exclude_ie: true do
    sign_in_as_admin

    visit '/users'
    expect(page).to have_content('Staff Directory')

    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('No Foster Agreement on File')

    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')

    page.attach_file('user_agreement_attributes_attachment', Rails.root.join("public", "docs", "Puppy-rescue-letter.pdf"))
    click_button('Update / Verify')

    expect(page).to have_no_css('#confidentiality-agreement-dl')
    within('#foster-agreement-dl') do
      expect(page).to have_content 'Puppy-rescue-letter'
    end
  end

  scenario 'Admin attaches a code of conduct agreement to a user', exclude_ie: true do
    sign_in_as_admin

    visit '/users'
    expect(page).to have_content('Staff Directory')

    click_link(user.name)
    expect(page).to have_content(user.name)
    expect(page).to have_content('No Code of Conduct Agreement on File')

    click_link('Update/Verify Profile')
    expect(page).to have_content('Edit Staff Account')

    page.attach_file('user_code_of_conduct_agreement_attributes_attachment', Rails.root.join("public", "docs", "new-puppy-info.pdf"))
    click_button('Update / Verify')

    expect(page).to have_no_css('#foster-agreement-dl')
    expect(page).to have_no_css('#confidentiality-agreement-dl')
    within('#code-of-conduct-agreement-dl') do
      expect(page).to have_content 'new-puppy-info'
    end
  end
end
