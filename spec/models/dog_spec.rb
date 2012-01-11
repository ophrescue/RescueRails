require 'spec_helper'

describe Dog do
  pending "add some examples to (or delete) #{__FILE__}"
end


# == Schema Information
#
# Table name: dogs
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  tracking_id          :integer
#  primary_breed_id     :integer
#  secondary_breed_id   :integer
#  status               :string(255)
#  age                  :string(75)
#  size                 :string(75)
#  is_altered           :boolean
#  gender               :string(6)
#  is_special_needs     :boolean
#  no_dogs              :boolean
#  no_cats              :boolean
#  no_kids              :boolean
#  description          :text
#  user_id              :integer
#  foster_start_date    :date
#  adoption_date        :date
#  is_uptodateonshots   :boolean         default(TRUE)
#  is_housetrained      :boolean         default(TRUE)
#  intake_dt            :date
#  available_on_dt      :date
#  has_medical_need     :boolean         default(FALSE)
#  is_high_priority     :boolean         default(FALSE)
#  needs_photos         :boolean         default(FALSE)
#  has_behavior_problem :boolean         default(FALSE)
#  needs_foster         :boolean         default(FALSE)
#

