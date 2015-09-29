# == Schema Information
#
# Table name: shelters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Shelter < ActiveRecord::Base
  attr_protected #disables whitelist in model TODO Remove after strong params 100% implemented
  include ActiveModel::ForbiddenAttributesProtection

  has_many :dogs
end
