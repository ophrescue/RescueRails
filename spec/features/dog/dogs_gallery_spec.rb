require 'rails_helper'
require_relative '../../helpers/application_helpers'

xfeature 'when user is not signed in', js: true do
  include ApplicationHelpers

  context "click on Dogs link in nav bar" do
    it "should lead to the public gallery page" do
      visit root_path
      page.find_by_id('dogs_main').click
      expect(page_heading).to eq 'Our Dogs'
    end
  end
end
