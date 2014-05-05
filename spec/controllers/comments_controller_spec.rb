require 'spec_helper'

describe CommentsController do

  describe 'POST #create' do
    context 'a form post is made' do
      it 'should succeed' do
        dog = create(:dog)
        post :create, dog_id: dog.id, comment: FactoryGirl.attributes_for(:comment)
      end
    end
  end
end
