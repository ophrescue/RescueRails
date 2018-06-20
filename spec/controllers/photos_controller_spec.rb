require 'rails_helper'

describe PhotosController, type: :controller do
  include_context 'signed in admin'

  let(:dog) { create(:dog_with_photo_and_attachment) }
  let(:photo) { create(:photo, dog: dog) }

  describe 'POST #sort' do
    it 'is successful' do
      post :sort, params: { dogs_manager_id: dog.id, photo: [photo] }
      expect(response).to be_successful
    end
  end
end
