require 'rails_helper'

describe VolunteerApp do
  let(:volunteer_app) { build(:volunteer_app) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(create(:volunteer_app)).to be_valid
    end
  end
end
