class Adoption < ActiveRecord::Base

	belongs_to :dog
	belongs_to :adopter

	attr_accessible :relation_type,
					:dog_id,
					:adopter_id

	# RELATION_TYPE = ['interested', 'adopted', 'returned',
	# 			'pending adoption', 'pending return', 'trial adoption']

	# validates_inclusion_of :adoption_type, :in => RELATION_TYPE	

end
# == Schema Information
#
# Table name: adoption
#
#  id              :integer         not null, primary key
#  adopter_id      :integer
#  dog_id          :integer
#  relation_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

