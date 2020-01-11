require 'rails_helper'
require_relative '../../helpers/application_helpers'
require_relative '../../helpers/cats_list_helper'

feature 'add a new dog', js: true do
  include ApplicationHelpers
  include CatsListHelper

  before do
    create(:dog)
    sign_in_as_admin
    visit cats_manager_index_path
    expect(page_heading).to eq "Cat Manager"
  end

  it "should cancel back to the manager list" do
    click_link "Add Cat"
    expect(page_heading).to eq "Add a New Cat"
    click_link "Cancel"
    expect(page_heading).to eq "Cat Manager"
  end

  it "save the new cat" do
    click_link "Add Cat"
    expect(page_heading).to eq "Add a New Cat"
    fill_in('Name', with: 'Fido')
    select('adoptable', from: 'Status')
    click_button "Submit"
    expect(page_heading).to eq "Cat Manager"
    expect(cat_names).to include "Fido"
  end
end
