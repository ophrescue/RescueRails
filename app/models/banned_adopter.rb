# == Schema Information
#
# Table name: banned_adopters
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  phone      :string(20)
#  email      :string(100)
#  city       :string(100)
#  state      :string(2)
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BannedAdopter < ActiveRecord::Base
  attr_accessible :name,
  				  :phone,
  				  :email,
  				  :city,
  				  :state,
  				  :comment






end
