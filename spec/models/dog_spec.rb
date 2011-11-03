require 'spec_helper'

describe Dog do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: dogs
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  tracking_id        :integer
#  primary_breed_id   :integer
#  secondary_breed_id :integer
#  status             :string(255)
#  age                :string(75)
#  size               :string(75)
#  is_altered         :boolean
#  gender             :string(6)
#  is_special_needs   :boolean
#  no_dogs            :boolean
#  no_cats            :boolean
#  no_kids            :boolean
#  description        :text
#  is_purebred        :boolean
#  user_id            :integer
#  foster_start_date  :date
#  adoption_date      :date
#

