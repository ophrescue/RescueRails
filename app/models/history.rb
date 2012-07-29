class History < ActiveRecord::Base

	belongs_to :user
	belongs_to :dog
end

# == Schema Information
#
# Table name: histories
#
#  id                :integer         not null, primary key
#  dog_id            :integer
#  user_id           :integer
#  foster_start_date :date
#  foster_end_date   :date
#  created_at        :timestamp(6)
#  updated_at        :timestamp(6)
#

