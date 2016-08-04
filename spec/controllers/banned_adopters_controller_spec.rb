# == Schema Information
#
# Table name: banned_adopters
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  phone      :string(20)
#  email      :string(100)
#  city       :string(100)
#  state      :string(2)
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe BannedAdoptersController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:hacker) { create(:user) }

  before :each do
    allow(controller).to receive(:current_user) { admin }
  end

  describe 'GET index' do
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    let(:banned_adopter) { create(:banned_adopter) }

    it 'is successful' do
      get :show, id: banned_adopter.id
      expect(response).to be_successful
    end
  end

  describe 'GET new ' do
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET edit' do
    let(:banned_adopter) { create(:banned_adopter) }

    it 'is successful' do
      get :edit, id: banned_adopter.id
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    context 'logged in as an admin' do

      it 'is able to create a banned adopter' do
        expect {
          post :create, banned_adopter: attributes_for(:banned_adopter)
        }.to change(BannedAdopter, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to create a banned adopter' do
        expect{
          post :create, banned_adopter: attributes_for(:banned_adopter)
        }.not_to change(BannedAdopter, :count)
      end
    end
  end

  describe 'PUT update' do
    let(:test_banned_adopter) { create(:banned_adopter, name: 'Joe Smith') }
    let(:request) { -> { put :update, id: test_banned_adopter.id, banned_adopter: attributes_for(:banned_adopter, name: 'Tom Jones') } }

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'updates the banned adopter name' do
        expect { request.call }.to change { test_banned_adopter.reload.name }.from('Joe Smith').to('Tom Jones')
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to modify banned adopter' do
        expect { request.call }.to_not change { test_banned_adopter.reload.name }
      end
    end
  end
end
