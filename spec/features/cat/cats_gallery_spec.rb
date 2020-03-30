require 'rails_helper'
require_relative '../../helpers/application_helpers'

feature 'when user is not signed in', js: true do
  include ApplicationHelpers

  context "click on Cats link in nav bar" do
    it "should lead to the public gallery page" do
      visit root_path
      page.find_by_id('cats_main').click
      expect(page_heading).to eq 'Our Cats'
    end
  end
end
