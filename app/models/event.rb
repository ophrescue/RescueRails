class Event < ActiveRecord::Base

	attr_accessible :title,
				  				:start_time,
				  				:end_time,
				  				:location_name,
				  				:address,
				  				:descriptoin,
									:latitude,
									:longitude

	validates_presence_of :title,
											  :start_time,
												:end_time,
												:location_name,
												:address,
												:description


	before_save :set_user

	geocoded_by :address
	
	after_validation :geocode,
  	:if => lambda{ |obj| obj.address_changed? }


	def set_user
		self.created_by = current_user.id
	end

end

# == Schema Information
#
# Table name: events
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  location_name   :string(255)
#  address         :string(255)
#  description     :text
#  created_by_user :integer
#  created_at      :datetime
#  updated_at      :datetime
#  latitude        :float
#  longitude       :float
#  start_time      :datetime
#  end_time        :datetime
#

