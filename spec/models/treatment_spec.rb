# == Schema Information
#
# Table name: treatments
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  available_for  :string           not null
#  has_result     :boolean          default(FALSE), not null
#  recommendation :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe Treatment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
