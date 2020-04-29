require 'rails_helper'

RSpec.describe "TreatmentRecords", type: :request do
  context 'foster of a dog user' do
    let!(:active_user) { create(:user, :foster) }
    let!(:dog) { create(:dog, foster_id: active_user.id) }
    let!(:treatment) { create(:treatment, available_for: 'Dog') }

    describe "GET #index" do
      it "is successful" do
        get dog_treatment_records_path(dog, as: active_user)
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:treatment_record) { create(:treatment_record, treatable_id: dog.id, treatable_type: 'Dog') }
      it 'is successful' do
        get dog_treatment_record_path(dog, treatment_record.id, as: active_user)
        expect(response).to redirect_to action: :index
      end
    end

    describe 'GET #new' do
      it 'is successful' do
        get new_dog_treatment_record_path(dog, treatment_id: treatment.id, as: active_user)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      let(:treatment_record) { create(:treatment_record, treatment_id: treatment.id, treatable_id: dog.id, treatable_type: 'Dog') }
      it 'is successful' do
        get edit_dog_treatment_record_path(dog, treatment_record.id, as: active_user)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'is able to create a treatment record' do
        treatment_record = attributes_for(:treatment_record)
        expect {
          post dog_treatment_records_path(dog, as: active_user), params: { treatment_record: treatment_record }
        }.to change(TreatmentRecord, :count).by(1)
      end
    end

    describe "PUT #update" do
      let(:test_treatment_record) { create(:treatment_record, treatment_id: treatment.id, treatable_id: dog.id, treatable_type: 'Dog', comment: 'old comment') }
      let(:request) { -> { put polymorphic_path([dog, test_treatment_record], as: active_user), params: { treatment_record: attributes_for(:treatment_record, comment: 'new hotness') } } }
      it 'can update a treatment name' do
        expect { request.call }.to change { test_treatment_record.reload.comment }.from('old comment').to('new hotness')
      end
    end
  end
end
