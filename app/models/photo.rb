class Photo < ActiveRecord::Base
	belongs_to :dog

	has_attached_file :photo, :styles => { :original => "1024x1024>", :large => "640x640", :medium => "320x320>", :thumb => "100x100>" }

end
