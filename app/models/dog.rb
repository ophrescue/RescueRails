# == Schema Information
#
# Table name: dogs
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Dog < ActiveRecord::Base
end

