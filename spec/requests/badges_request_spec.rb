require 'rails_helper'

describe "Badges", type: :request do
  context 'admin user' do
    let(:admin) { create(:user, :admin) }
    describe "GET #index" do
      it "is successful" do
        get badges_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:badge) { create(:badge) }
      it 'is successful' do
        get badge_path(badge.id, as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'is successful' do
        get new_badge_path(as: admin)
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      let(:badge) { create(:badge) }
      it 'is successful' do
        get edit_badge_path(badge.id, as: admin)
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      it 'is able to create a badge' do
        badge = attributes_for(:badge)
        expect {
          post badges_path(as: admin), params: { badge: badge }
        }.to change(Badge, :count).by(1)
      end
    end

    describe "PUT #update" do
      let(:test_badge) { create(:badge, title: 'old title') }
      let(:request) { -> { put badge_path(test_badge.id, as: admin), params: { badge: attributes_for(:badge, title: 'new hotness') } } }
      it 'can update a badge title' do
        expect { request.call }.to change { test_badge.reload.title }.from('old title').to('new hotness')
      end
    end

    describe "DELETE #delete" do
      let!(:badge) { create(:badge) }
      let(:request) { -> { delete badge_path(badge.id, as: admin) } }
      it 'can delete the badge' do
        expect { request.call }.to change(Badge, :count).by(-1)
      end
    end
  end

  context 'normal user' do
    let(:user) { create(:user) }
    describe "GET #index" do
      it "is successful" do
        get badges_path(as: user)
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      let(:badge) { create(:badge) }
      it 'is successful' do
        get badge_path(badge.id, as: user)
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'is blocked' do
        get new_badge_path(as: user)
        expect(response).to_not be_successful
      end
    end

    describe 'GET #edit' do
      let(:badge) { create(:badge) }
      it 'is blocked' do
        get edit_badge_path(badge.id, as: user)
        expect(response).to_not be_successful
      end
    end

    describe "POST #create" do
      it 'is unable to create a badge' do
        badge = attributes_for(:badge)
        expect {
          post badges_path(as: user), params: { badge: badge }
        }.to_not change(Badge, :count)
      end
    end

    describe "PUT #update" do
      let(:test_badge) { create(:badge, title: 'old title') }
      let(:request) { -> { put badge_path(test_badge.id, as: user), params: { badge: attributes_for(:badge, title: 'new hotness') } } }
      it 'can not update a badge title' do
        expect { request.call }.to_not(change { test_badge.reload.title })
      end
    end

    describe "DELETE #delete" do
      let(:badge) { create(:badge) }
      it 'can NOT delete the badge' do
        delete badge_path(badge.id, as: user)
        expect(response).to_not be_successful
      end
    end
  end
end
