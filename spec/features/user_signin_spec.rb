require 'rails_helper'

feature 'Sign in as Admin', js: true do
  let(:admin) { create(:user, add_dogs: true) }

  scenario 'Valid User' do
    visit '/sign_in'
    expect(page.evaluate_script("document.activeElement.id")).to eq 'session_email'

    fill_and_submit(admin)
    expect(page).to have_no_content('Invalid')
  end

  # repro for issue #707
  scenario 'Redirect to Original Destination' do
    visit '/dogs/new'
    expect(page).to have_content('Please sign in to access this page')

    fill_and_submit(admin)
    expect(current_path).to eql('/dogs/new')
  end

  # test for side-effects of issue #707 fix
  scenario 'Original Destination Redirect is Cleared' do
    visit '/dogs/new'
    visit '/sign_in'

    fill_and_submit(admin)
    expect(current_path).to eql('/')
  end
end
