# == Schema Information
#
# Table name: references
#
#  id           :integer          not null, primary key
#  adopter_id   :integer
#  name         :string(255)
#  email        :string(255)
#  phone        :string(255)
#  relationship :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  whentocall   :string(255)
#

class Reference < ApplicationRecord

  belongs_to :adopter, class_name: 'Adopter'
end
