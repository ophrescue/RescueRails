# == Schema Information
#
# Table name: references
#
#  id           :integer          not null, primary key
#  adopter_id   :integer
#  name         :string
#  email        :string
#  phone        :string
#  relationship :string
#  created_at   :datetime
#  updated_at   :datetime
#  whentocall   :string
#

require 'rails_helper'

describe Reference do
  let(:reference) { build(:reference) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(reference).to be_valid
    end
  end
end
