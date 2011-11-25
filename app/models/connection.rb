class Connection < ActiveRecord::Base

	belongs_to :dog
	belongs_to :adopter

	TYPE = ['interested', 'adopted', 'returned',
				'pending adoption', 'pending return', 'trial adoption']

	validates_inclusion_of :type, :in => TYPE	

end
# == Schema Information
#
# Table name: connections
#
#  id              :integer         not null, primary key
#  adopter_id      :integer
#  dog_id          :integer
#  connection_type :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

