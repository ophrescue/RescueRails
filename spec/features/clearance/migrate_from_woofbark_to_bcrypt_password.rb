require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "Visitor signs in while having old password encryption" do
  scenario "with old password encryption" do
    user = FactoryBot.create(:user)

    # value of password: "test_password"
    user.update(
      encrypted_password: "468ac71357be666f3531210cbe3375221fe6a1874529ab9329174f671c4b9a79",
      salt: "11f5ea81337fe4a09511556536ce65feb9ecfe1652652e5d1ad4793c931fc37e"
    )

    sign_in_with user.email, 'test_password'

    # password gets updated to bcrypt on login
    expect(user.reload.encrypted_password.starts_with?('$2a$')).to eq(true)
  end
end
