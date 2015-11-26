# == Schema Information
#
# Table name: adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  dog_id        :integer
#  relation_type :string(255)
#  created_at    :timestamp(6)
#  updated_at    :timestamp(6)
#

class Adoption < ActiveRecord::Base

  belongs_to :dog
  belongs_to :adopter

  RELATION_TYPE = ['interested', 'adopted', 'returned',
        'pending adoption', 'pending return', 'trial adoption']

  validates_inclusion_of :relation_type, in: RELATION_TYPE
end
