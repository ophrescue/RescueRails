# == Schema Information
#
# Table name: treatments
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  available_for  :string           not null
#  has_result     :boolean          default(FALSE), not null
#  recommendation :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Treatment, type: :model do
  let(:treatment) { build(:treatment) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:treatment)).to be_valid
    end
  end
end
