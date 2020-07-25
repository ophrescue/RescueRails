require 'rails_helper'

describe "Bulletins Requests", type: :request do
  context 'admin user' do
    let(:admin) { create(:user, :admin) }
    describe "GET #index" do
      it "is successful" do
        get bulletins_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:bulletin) { create(:bulletin) }
      it 'is successful' do
        get bulletin_path(bulletin.id, as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'is successful' do
        get new_bulletin_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      let(:bulletin) { create(:bulletin) }
      it 'is successful' do
        get edit_bulletin_path(bulletin.id, as: admin)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'is able to create a bulletin' do
        bulletin = attributes_for(:bulletin)
        expect {
          post bulletins_path(as: admin), params: { bulletin: bulletin }
        }.to change(Bulletin, :count).by(1)
      end
    end

    describe "PUT #update" do
      let(:test_bulletin) { create(:bulletin, title: 'old title') }
      let(:request) { -> { put bulletin_path(test_bulletin.id, as: admin), params: { bulletin: attributes_for(:bulletin, title: 'new hotness') } } }
      it 'can update a bulletin title' do
        expect { request.call }.to change { test_bulletin.reload.title }.from('old title').to('new hotness')
      end
    end

    describe "DELETE #delete" do
      let!(:bulletin) { create(:bulletin) }
      let(:request) { -> { delete bulletin_path(bulletin.id, as: admin) } }
      it 'can delete the bulletin' do
        expect { request.call }.to change(Bulletin, :count).by(-1)
      end
    end
  end

  context 'normal user' do
    let(:user) { create(:user) }
    describe "GET #index" do
      it "is successful" do
        get bulletins_path(as: user)
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:bulletin) { create(:bulletin) }
      it 'is successful' do
        get bulletin_path(bulletin.id, as: user)
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'is blocked' do
        get new_bulletin_path(as: user)
        expect(response).to_not be_successful
      end
    end

    describe 'GET #edit' do
      let(:bulletin) { create(:bulletin) }
      it 'is blocked' do
        get edit_bulletin_path(bulletin.id, as: user)
        expect(response).to_not be_successful
      end
    end

    describe "POST #create" do
      it 'is unable to create a bulletin' do
        bulletin = attributes_for(:bulletin)
        expect {
          post bulletins_path(as: user), params: { bulletin: bulletin }
        }.to_not change(Bulletin, :count)
      end
    end

    describe "PUT #update" do
      let(:test_bulletin) { create(:bulletin, title: 'old title') }
      let(:request) { -> { put bulletin_path(test_bulletin.id, as: user), params: { bulletin: attributes_for(:bulletin, title: 'new hotness') } } }
      it 'can not update a bulletin title' do
        expect { request.call }.to_not(change { test_bulletin.reload.title })
      end
    end

    describe "DELETE #delete" do
      let(:bulletin) { create(:bulletin) }
      it 'can NOT delete the bulletin' do
        delete bulletin_path(bulletin.id, as: user)
        expect(response).to_not be_successful
      end
    end
  end
end
