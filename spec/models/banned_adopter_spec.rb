# == Schema Information
#
# Table name: banned_adopters
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  phone      :string(20)
#  email      :string(100)
#  city       :string(100)
#  state      :string(2)
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe AdoptionApp do
  let(:banned_adopter) { build(:banned_adopter) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:banned_adopter)).to be_valid
    end
  end
end
