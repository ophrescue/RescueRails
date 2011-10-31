class Photo < ActiveRecord::Base
	belongs_to :dog

	has_attached_file :photo, :styles => { :original => "1024x1024>", :large => "640x640", :medium => "320x320>", :thumb => "100x100>" }

	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']
end
