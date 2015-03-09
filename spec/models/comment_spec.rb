# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :timestamp(6)
#  updated_at       :timestamp(6)
#

require 'spec_helper'

describe Comment do
  let(:comment) { build(:comment) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:comment)).to be_valid
    end
  end
end
