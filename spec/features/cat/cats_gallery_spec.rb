require 'rails_helper'
require_relative '../../helpers/application_helpers'

feature 'when user is not signed in', js: true do
  include ApplicationHelpers

  # TODO turn test back on after opening DMS Cats to public

  # context "click on Cats link in nav bar" do
  #   it "should lead to the public gallery page" do
  #     visit root_path
  #     page.find_link('Cats').click
  #     expect(page_heading).to eq 'Our Cats'
  #   end
  # end
end
