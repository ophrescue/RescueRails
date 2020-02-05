# == Schema Information
#
# Table name: cat_breed
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
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
