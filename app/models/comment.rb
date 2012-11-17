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

class Comment < ActiveRecord::Base

	belongs_to :commentable, :polymorphic => true

	attr_accessible :content

	belongs_to :user
	
end

