class Fosters < ActiveRecord::Base

	belongs_to :user
	belongs_to :dog

end
# == Schema Information
#
# Table name: fosters
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  dog_id     :integer         not null
#  start_date :date            not null
#  end_date   :date
#  updated_by :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

