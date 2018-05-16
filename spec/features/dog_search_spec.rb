require 'rails_helper'
require_relative '../helpers/application_helpers'

feature 'visit manager view', js: true do
  include ApplicationHelpers

  let!(:active_user) { create(:user, :admin) }

  scenario 'user is not signed in (issues #771)' do
    expect{ visit '/dogs?search=xyz&commit=Search' }.not_to raise_exception
    expect(page_heading).to eq 'Staff Sign in'
    expect(flash_error_message).to eq 'You must be signed in to search the list of dogs'
    sign_in(active_user)
    expect(page_heading).to eq "Our Dogs"
  end
end

