# == Schema Information
#
# Table name: dogs
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  tracking_id      :integer
#  breed_id         :integer
#  age              :string(75)
#  size             :string(75)
#  is_altered       :boolean
#  gender           :string(6)
#  is_special_needs :boolean
#  no_dogs          :boolean
#  no_cats          :boolean
#  no_kids          :boolean
#  status           :string(255)
#

class Dog < ActiveRecord::Base
end

