require 'rails_helper'

describe "Adoption Requests", type: :request do
  context 'admin user' do
    let(:admin) { create(:user, :admin)}

    describe "DELETE interested adoption" do
      let!(:adoption_interested) { create(:adoption, relation_type: 'interested')}
      let(:request) { -> { delete adoption_path(adoption_interested.id, as: admin) } }
      it 'should be deleted' do
        expect { request.call }.to change(Adoption, :count).by(-1)
      end
    end

    describe "DELETE returned adoption" do
      let!(:adoption_returned) { create(:adoption, relation_type: 'returned')}
      let(:request) { -> { delete adoption_path(adoption_returned.id, as: admin) } }
      it 'should be deleted' do
        expect { request.call }.to change(Adoption, :count).by(-1)
      end
    end

  end
end
