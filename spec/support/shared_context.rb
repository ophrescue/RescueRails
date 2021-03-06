RSpec.shared_context 'signed in admin' do
  let(:admin) { create(:user, :admin) }

  before do
    sign_in_as(admin)
  end
end

RSpec.shared_context 'signed in event manager' do
  let(:event_manager) { create(:user, :event_manager) }

  before do
    sign_in_as(event_manager)
  end
end

RSpec.shared_context 'signed in user' do
  let(:user) { create(:user) }

  before do
    sign_in_as(user)
  end
end
