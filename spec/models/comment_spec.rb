# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

describe Comment do
  let(:comment) { build(:comment) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:comment)).to be_valid
    end
  end
end
