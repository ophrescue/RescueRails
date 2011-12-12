# == Schema Information
#
# Table name: events
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  start_ts        :datetime
#  end_ts          :datetime
#  location_name   :string(255)
#  address         :string(255)
#  description     :text
#  created_by_user :integer
#  created_at      :datetime
#  updated_at      :datetime
#
class Event < ActiveRecord::Base

	attr_accessible :title,
				  				:start_ts,
				  				:end_ts,
				  				:location_name,
				  				:address,
				  				:descriptoin

	validates_presence_of :title,
											  :start_ts,
												:end_ts,
												:location_name,
												:address,
												:description

	before_save :set_user



	def set_user
		self.created_by = current_user.id
	end

end

