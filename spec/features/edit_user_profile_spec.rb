require 'rails_helper'

feature 'Edit User Profile', js: true do
  let!(:user) { create(:user, active: true) }

  scenario 'Admin is presented with non-disabled name field' do
    sign_in_as_admin

    visit '/users'
    click_link(user.name)
    click_link('Update/Verify Profile')
    expect(page.find_field('Name').disabled?).to eq(false)
  end

  scenario 'Admin is presented with non-disabled email field ' do
    sign_in_as_admin
    visit '/users'
    click_link(user.name)
    click_link('Update/Verify Profile')
    expect(page.find_field('Email').disabled?).to eq(false)
  end

  # field still appears visually on the screen but is not detectable because it
  # is disabled
  scenario 'User is presented with disabled name field' do
    sign_in_as(user)
    visit '/users'
    click_link(user.name)
    click_link('Update/Verify Profile')
    expect(page.has_field?('Name')).to eq(false)
  end

  # field still appears visually on the screen but is not detectable because it
  # is disabled
  scenario 'User is presented with disabled email field' do
    sign_in_as(user)
    visit '/users'
    click_link(user.name)
    click_link('Update/Verify Profile')
    expect(page.has_field?('Email')).to eq(false)
  end
end
