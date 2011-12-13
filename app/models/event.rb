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
#  start_datetime  :datetime
#  end_datetime    :datetime
#

class Event < ActiveRecord::Base

	attr_accessible :title,
				  				:start_datetime,
				  				:end_datetime,
				  				:location_name,
				  				:address,
				  				:description,
									:latitude,
									:longitude

	validates_presence_of :title,
											  :start_datetime,
												:end_datetime,
												:location_name,
												:address,
												:description


	before_save :set_user

	geocoded_by :address
	
	after_validation :geocode,
  	:if => lambda{ |obj| obj.address_changed? }


	def set_user
		self.created_by_user = @current_user
	end

end

