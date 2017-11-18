require 'rails_helper'

feature "User Permissions", js: true do
    let!(:admin) { create(:user, :admin) }
    let!(:inactive_user) { create(:user, admin: FALSE, active: FALSE)}

    context "Inactive Volunteer User" do

        before :each do
            sign_in(inactive_user)
          end

        scenario "cannot view private dog information"

        scenario "cannot view the Do Not Adopt List"

    end

end