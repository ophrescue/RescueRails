require 'rails_helper'

RSpec.describe "Treatments", type: :request do
  context 'admin user' do
    let(:admin) { create(:user, :admin) }
    describe "GET #index" do
      it "is successful" do
        get treatments_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:treatment) { create(:treatment) }
      it 'is successful' do
        get treatment_path(treatment.id, as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'is successful' do
        get new_treatment_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      let(:treatment) { create(:treatment) }
      it 'is successful' do
        get edit_treatment_path(treatment.id, as: admin)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'is able to create a treatment' do
        treatment = attributes_for(:treatment)
        expect {
          post treatments_path(as: admin), params: { treatment: treatment }
        }.to change(Treatment, :count).by(1)
      end
    end

    describe "PUT #update" do
      let(:test_treatment) { create(:treatment, name: 'old title') }
      let(:request) { -> { put treatment_path(test_treatment.id, as: admin), params: { treatment: attributes_for(:treatment, name: 'new hotness') } } }
      it 'can update a bulletin title' do
        expect { request.call }.to change { test_treatment.reload.name }.from('old title').to('new hotness')
      end
    end
  end
end
