class Event < ActiveRecord::Base

	attr_accessible :title,
				  				:event_date,
				  				:start_time,
				  				:end_time,
				  				:location_name,
				  				:location_url,
				  				:address,
				  				:description,
								:latitude,
								:longitude,
								:photo,
								:photo_file_name,
								:photo_content_type,
								:photo_file_size,    
								:photo_updated_at   

	validates_presence_of :title,
					  	  :event_date,
				  		  :start_time,
				  		  :end_time,
						  :location_name,
						  :address,
						  :description

	validates_format_of :location_url, :with => URI::regexp(%w(http https))

	before_save :set_user

	# geocoded_by :address
	
	# after_validation :geocode,
 #  	:if => lambda{ |obj| obj.address_changed? }

	has_attached_file :photo,
					  :styles => { :original => "1024x1024>",
								   :medium => "205x195>",
								   :thumb => "64x64>" },
					  :path => ":rails_root/public/system/event_photo/:id/:style/:filename",
					  :url  => "/system/event_photo/:id/:style/:filename"

	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']




	def set_user
		self.created_by_user = @current_user
	end

end


# == Schema Information
#
# Table name: events
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  location_name      :string(255)
#  address            :string(255)
#  description        :text
#  created_by_user    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  latitude           :float
#  longitude          :float
#  event_date         :date
#  start_time         :time
#  end_time           :time
#  location_url       :string(255)
#  location_phone     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

