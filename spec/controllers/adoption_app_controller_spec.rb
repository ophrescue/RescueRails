require 'rails_helper'

describe AdoptionAppController, type: :controller do
  describe 'PUT update' do
    include_context 'signed in admin'

    let(:adopter) { create(:adopter, :with_app) }
    let(:adoption_app) { adopter.adoption_app }

    it 'is successful' do
      request.env['HTTP_REFERER'] = '/'
      put :update, params: { id: adoption_app.id, adoption_app: { spouse_name: 'spouse' } }
      expect(response).to redirect_to(root_path)
    end
  end
end
