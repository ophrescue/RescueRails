require 'spec_helper'

describe CommentsController, type: :controller do
  let!(:user) { build(:user) }
  before(:each) do
    user.stub(:chimp_subscribe).and_return(true)
    user.save
    controller.stub(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'a form post is made' do
      it 'should succeed' do
        request.env["HTTP_REFERER"] = "/"
        dog = create(:dog)
        post :create, { dog_id: dog.id, comment: FactoryGirl.attributes_for(:comment) }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'an ajax call is made' do
      it 'should succeed' do
        dog = create(:dog)
        xhr :post, :create, { dog_id: dog.id, comment: FactoryGirl.attributes_for(:comment) }
        expect(response.status).to eq(200)
        expect(response).not_to be_redirect
      end
    end
  end
end
