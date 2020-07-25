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

    describe "DELETE paid invoice" do
      let!(:invoice) { create(:invoice_unpaid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      it 'can NOT delete the paid invoice' do
        delete invoice_path(invoice.id)
        expect(response).to_not be_successful
      end
    end

  end

  context "Authorized User" do
    let!(:admin) { create(:user, :admin) }
    let!(:adopter) { create(:adopter) }
    let!(:dog) { create(:dog) }
    let!(:adoption) { create(:adoption, adopter_id: adopter.id, dog_id: dog.id )}

    describe "GET #index" do
      let(:invoice) { create(:invoice_paid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      it 'is successful' do
        get invoices_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'is able to create an invoice' do
        invoice = attributes_for(:invoice_unpaid)
        expect {
          post adoption_invoices_path(adoption, as: admin), params: { invoice: invoice }
        }.to change(Invoice, :count).by(1)
      end
    end

    describe "DELETE open invoice" do
      let!(:invoice) { create(:invoice_unpaid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      let(:request) { -> { delete invoice_path(invoice.id, as: admin) } }
      it 'can delete the open invoice' do
        expect { request.call }.to change(Invoice, :count).by(-1)
      end
    end

    describe "DELETE paid invoice" do
      let!(:invoice) { create(:invoice_paid, invoiceable_id: adoption.id, invoiceable_type: 'Adoption') }
      let(:request) { -> { delete invoice_path(invoice.id, as: admin) } }
      it 'can NOT delete the paid invoice' do
        expect { request.call }.to change(Invoice, :count).by(0)
      end
    end




  end


end
