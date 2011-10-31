class Photo < ActiveRecord::Base
	belongs_to :dog

	has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

end
