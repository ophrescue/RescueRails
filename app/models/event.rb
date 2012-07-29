class Event < ActiveRecord::Base

	attr_accessor :photo_delete

	attr_accessible :title,
	  				:event_date,
	  				:start_time,
	  				:end_time,
	  				:location_name,
	  				:location_url,
	  				:photographer_name,
	  				:photographer_url,
	  				:location_phone,
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

	geocoded_by :address
	
	after_validation :geocode,
 	 	:if => lambda{ |obj| obj.address_changed? }

	has_attached_file :photo,
					  :styles => { :original => "1024x1024>",
								   :medium => "205x300>",
								   :thumb => "64x64>" },
					  				:path => ":rails_root/public/system/event_photo/:id/:style/:filename",
					  				:url  => "/system/event_photo/:id/:style/:filename"

	
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']

	before_save :delete_photo?


	def set_user
		self.created_by_user = @current_user
	end

	private
	  def delete_photo?
	    self.photo.clear if self.photo_delete == "1"
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
#  created_at         :timestamp(6)
#  updated_at         :timestamp(6)
#  latitude           :float
#  longitude          :float
#  event_date         :date
#  start_time         :time(6)
#  end_time           :time(6)
#  location_url       :string(255)
#  location_phone     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :timestamp(6)
#  photographer_name  :string(255)
#  photographer_url   :string(255)
#

