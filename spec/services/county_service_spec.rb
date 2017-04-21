require 'rails_helper'

RSpec.describe CountyService do
  # probably no point in testing since it will always return what
  # is passed in during testing
  # Ensure we don't break this so we're not wasting calls during tests I guess
  describe '.fetch' do
    let(:zip) { '10013' }
    subject { described_class.fetch(zip) }

    it { is_expected.to eq('10013') }
  end
end
