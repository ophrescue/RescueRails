# == Schema Information
#
# Table name: cat_breeds
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe CatBreed do
  let(:cat_breed) { build(:cat_breed) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(create(:breed)).to be_valid
    end
  end
end
