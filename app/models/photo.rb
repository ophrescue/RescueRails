class Photo < ActiveRecord::Base
	belongs_to :dog

	 has_attached_file :dogpic, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
