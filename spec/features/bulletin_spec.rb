require 'rails_helper'

feature 'Bulletins', js: true do
  scenario 'visit Bulletins as volunteer' do
    sign_in_as_admin
    visit bulletins_path
    expect(page).to have_content 'Bulletins'
  end

  scenario 'visit Bulletins as public user' do
    visit bulletins
    expect(current_path).to eq sign_in_path
  end
end
