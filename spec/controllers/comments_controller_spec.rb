# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

describe CommentsController, type: :controller do
  let!(:user) { create(:user) }

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    include_context 'signed in user'

    let(:dog) { create(:dog) }

    it 'is successful' do
      get :index, dog_id: dog.id
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    include_context 'signed in user'

    let(:comment) { create(:comment) }

    it 'is successful' do
      get :show, id: comment.id
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'a form post is made' do
      it 'should succeed' do
        request.env['HTTP_REFERER'] = '/'
        dog = create(:dog)
        post :create, { dog_id: dog.id, comment: FactoryGirl.attributes_for(:comment) }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'an ajax call is made' do
      it 'should succeed' do
        dog = create(:dog)
        xhr :post, :create, dog_id: dog.id, comment: FactoryGirl.attributes_for(:comment)
        expect(response.status).to eq(200)
        expect(response).not_to be_redirect
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, id: comment.id, comment: { content: 'Hi' } }

    let(:user) { create(:user) }
    let(:comment) { create(:comment, user_id: user.id) }

    before do
      allow(controller).to receive(:current_user) { current_user }
    end

    context 'user created comment being updated' do
      let(:current_user) { user }

      it 'updates the comment' do
        expect_any_instance_of(Comment).to receive(:update_attributes)
        subject
        expect(response).to be_ok
      end
    end

    context 'user did not create comment being updated' do
      let(:current_user) { create(:user) }

      it 'returns unauthorized' do
        subject

        expect(response).to be_unauthorized
      end
    end
  end

  describe '#find_commentable' do
    subject { controller.send(:find_commentable) }

    let(:dog) { create(:dog) }

    before do
      allow(controller).to receive(:params) { params }
    end

    context 'params contains _id param' do
      let(:params) { { dog_id: dog.id } }

      it 'returns dog' do
        expect(subject).to eq(dog)
      end
    end

    context 'params does not contain _id param' do
      let(:params) { { something: 1 } }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end
end
