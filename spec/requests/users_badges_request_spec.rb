require 'rails_helper'

describe "Badge Link Requests", type: :request do
  context 'normal user' do
    let(:user) { create(:user)}
    let(:badge) { create(:badge)}

    describe "Post badge link flow" do

      let(:request) { -> { post users_badges_path(badge_id: badge.id, as: user) } }
      it 'should be created' do
        expect { request.call }.to change(user.badges, :count).by(1)
      end

      let(:remove) { -> { delete users_badge_path(1, badge_id: badge.id, as: user) } }
      it 'should be deleted' do
        post users_badges_path(badge_id: badge.id, as: user)
        expect { remove.call }.to change(user.badges, :count).by(-1)
      end
    end
  end
end
