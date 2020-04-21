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
class TreatmentRecord < ApplicationRecord
  belongs_to :treatment
  belongs_to :treatable, polymorphic: true
end
