# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Folder < ActiveRecord::Base

  has_many :attachments, -> { order('updated_at DESC') }, as: :attachable

  accepts_nested_attributes_for :attachments, allow_destroy: true
end
