require 'rails_helper'

describe AdoptionAppController, type: :controller do
  describe 'PUT update' do
    include_context 'signed in'

    let(:adopter) { create(:adopter_with_app) }
    let(:adoption_app) { adopter.adoption_app }

    it 'is successful' do
      request.env['HTTP_REFERER'] = '/'
      put :update, id: adoption_app.id, adoption_app: { spouse_name: 'spouse' }
      expect(response).to redirect_to(root_path)
    end
  end
end
