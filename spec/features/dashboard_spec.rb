require 'rails_helper'

feature 'Dashboard', js: true do
  scenario 'visit dashboard as volunteer' do
    sign_in_as_admin
    visit dashboards_path
    expect(page).to have_content 'Bulletins'
  end

  scenario 'visit dashboard as public user' do
    visit dashboards_path
    expect(current_path).to eq sign_in_path
  end
end
