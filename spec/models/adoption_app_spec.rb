require 'spec_helper'

describe AdoptionApp do
  let(:adoption_app) { build(:adoption_app) }

  context 'has a valid factory' do
    it 'saves' do
      expect(adoption_app.valid?).to be_true
    end
  end
end
