require 'rails_helper'

RSpec.describe "VolunteerApps", type: :request do
  context 'pubic applications' do

    describe 'GET #new' do
      it 'is successful' do
        get new_volunteer_app_path()
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it "is able to create a volunteer application" do
        volunteer_app = attributes_for(:volunteer_app)
        expect {
          post volunteer_apps_path(params: { volunteer_app: volunteer_app})
        }.to change(VolunteerApp, :count).by(1)
      end
    end
  end
end
