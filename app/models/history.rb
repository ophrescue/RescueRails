class History < ActiveRecord::Base

	belongs_to :user
	belongs_to :dog
end
# == Schema Information
#
# Table name: histories
#
#  id         :integer         not null, primary key
#  dog_id     :integer
#  user_id    :integer
#  start_date :date
#  end_date   :date
#  created_at :datetime
#  updated_at :datetime
#

