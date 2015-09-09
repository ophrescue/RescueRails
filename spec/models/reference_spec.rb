# == Schema Information
#
# Table name: references
#
#  id           :integer          not null, primary key
#  adopter_id   :integer
#  name         :string(255)
#  email        :string(255)
#  phone        :string(255)
#  relationship :string(255)
#  created_at   :timestamp(6)
#  updated_at   :timestamp(6)
#  whentocall   :string(255)
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
