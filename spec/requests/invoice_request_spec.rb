require 'rails_helper'

RSpec.describe "Invoices" do
  context "Public User" do
    let!(:adopter) { create(:adopter) }
    let!(:dog) { create(:dog) }
    let!(:adoption) { create(:adoption, adopter_id: adopter.id, dog_id: dog.id )}

    describe "GET #show unpaid invoice" do
      let(:invoice) { create(:invoice_unpaid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      it 'is successful' do
        get invoice_path(invoice.slug)
        expect(response).to be_successful
      end
    end

    describe "GET #show paid invoice" do
      let(:invoice) { create(:invoice_paid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      it 'is successful' do
        get invoice_path(invoice.slug)
        expect(response).to be_successful
      end
    end

    describe "GET #index" do
      it 'should redirect to /sign_in' do
        get invoices_path
        expect(response).to redirect_to('/sign_in')
      end
    end
  end

  context "Authorized User" do
    let!(:active_user) { create(:user, :admin) }
    let!(:adopter) { create(:adopter) }
    let!(:dog) { create(:dog) }
    let!(:adoption) { create(:adoption, adopter_id: adopter.id, dog_id: dog.id )}

    describe "GET #index" do
      let(:invoice) { create(:invoice_paid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      it 'is successful' do
        get invoices_path(as: active_user)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'is able to create an invoice' do
        invoice = attributes_for(:invoice_unpaid)
        expect {
          post adoption_invoices_path(adoption, as: active_user), params: { invoice: invoice }
        }.to change(Invoice, :count).by(1)
      end
    end


  end


end
