RSpec.shared_context 'signed in' do
  let(:admin) { create(:user, :admin) }

  before do
    allow(controller).to receive(:current_user) { admin }
  end
end
