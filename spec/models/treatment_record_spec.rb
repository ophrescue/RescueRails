# == Schema Information
#
# Table name: treatment_records
#
#  id                :bigint           not null, primary key
#  treatment_id      :integer
#  treatable_id      :integer
#  treatable_type    :string
#  administered_date :date
#  results           :string
#  comments          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe TreatmentRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
