class Breed < ActiveRecord::Base

	has_many :dog

end
# == Schema Information
#
# Table name: breeds
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

