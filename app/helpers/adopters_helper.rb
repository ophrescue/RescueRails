# == Schema Information
#
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  phone               :string(255)
#  address1            :string(255)
#  address2            :string(255)
#  city                :string(255)
#  state               :string(255)
#  zip                 :string(255)
#  status              :string(255)
#  when_to_call        :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string(255)
#  other_phone         :string(255)
#  assigned_to_user_id :integer
#  flag                :string(255)
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#

module AdoptersHelper
  def max_hours_alone_label(hrs_alone)
    case
    when hrs_alone.nil?
      raw("<span class='label label-warning'>?? hrs alone</span>")
    when hrs_alone > 5
      raw("<span class='label label-warning'>#{hrs_alone} hrs alone</span>")
    else
      raw("<span class='label label-success'>#{hrs_alone} hrs alone</span>")
     end
  end
end
