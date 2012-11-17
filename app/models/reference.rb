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

class Reference < ActiveRecord::Base

	belongs_to :adopter, :class_name => 'Adopter'
	
	attr_accessible :name,
					:phone,
					:email,
					:relationship,
					:whentocall

end

