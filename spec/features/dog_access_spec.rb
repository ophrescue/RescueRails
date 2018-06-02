require 'rails_helper'
require_relative '../helpers/application_helpers.rb'

feature 'control access to dogs pages by user privileges' do
  include ApplicationHelpers

  let(:inactive_user){ FactoryBot.create(:user, active: false) }
  let(:active_user){ FactoryBot.create(:user, active: true) }

  scenario 'user is not logged-in' do
    visit dogs_manager_path
    expect(page_heading).to eq "Staff Sign in"
  end

  scenario 'user is logged-in but not active' do
    sign_in(inactive_user)
    visit dogs_manager_path
    expect(page_heading).to eq "Our Dogs"
  end

  scenario 'user is logged-in and active' do
    sign_in(active_user)
    visit dogs_manager_path
    expect(page_heading).to eq "Dog Manager"
  end
end
