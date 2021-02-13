require 'rails_helper'

describe "Adoption Application Creation", type: :request do
  let(:first_adopter) { create(:adopter, :with_app)}
  it "Can Not Create Duplicate application" do

    duplicate_adopter = attributes_for(:adopter, :with_app, email: first_adopter.email)
    puts duplicate_adopter
    expect {
      post adopters_path, params: { adopter: duplicate_adopter }
    }.to change(Adopter, :count).by(0)
  end
  it "Will not allow duplicate email in different case" do
    duplicate_adopter_case = attributes_for(:adopter, :with_app, email: first_adopter.email.upcase)
    puts duplicate_adopter_case
    expect {
      post adopters_path, params: { adopter: duplicate_adopter_case }
    }.to change(Adopter, :count).by(0)
  end
end
