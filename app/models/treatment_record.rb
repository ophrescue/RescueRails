# == Schema Information
#
# Table name: treatment_records
#
#  id                :bigint           not null, primary key
#  treatment_id      :integer
#  user_id           :bigint
#  treatable_id      :integer
#  treatable_type    :string
#  administered_date :date
#  due_date          :date
#  result            :string
#  comment           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class TreatmentRecord < ApplicationRecord
  belongs_to :treatment
  belongs_to :treatable, polymorphic: true
  belongs_to :user

  TEST_RESULT = ['positive', 'negative'].freeze
end
