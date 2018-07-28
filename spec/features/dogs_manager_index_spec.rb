require 'rails_helper'
require_relative '../helpers/application_helpers'
require_relative '../helpers/dogs_list_helper'

feature 'add a new dog', js: true do
  include ApplicationHelpers
  include DogsListHelper

  before do
    create(:dog)
    sign_in_as_admin
    visit dogs_manager_index_path
    expect(page_heading).to eq "Dog Manager"
  end

  it "should cancel back to the manager list" do
    click_link "Add a Dog"
    expect(page_heading).to eq "Add a New Dog"
    click_link "Cancel"
    expect(page_heading).to eq "Dog Manager"
  end

  it "save the new dog" do
    click_link "Add a Dog"
    expect(page_heading).to eq "Add a New Dog"
    fill_in('Name', with: 'Fido')
    select('adoptable', from: 'Status')
    click_button "Submit"
    expect(page_heading).to eq "Dog Manager"
    expect(dog_names).to include "Fido"
  end
end

feature 'edit a dog', js: true do
  include ApplicationHelpers

  let!(:dog) { create(:dog) }

  before do
    sign_in_as_admin
    visit edit_dogs_manager_path(dog)
    expect(page_heading).to eq "Edit Dog"
  end

  it 'should cancel back to the manager list' do
    click_link "Cancel"
    expect(page_heading).to eq "Dog Manager"
  end

  it "update dog attributes" do
    fill_in('Name', with: 'Rover')
    click_button "Submit"
    expect(page_heading).to match  /Rover/
  end
end
