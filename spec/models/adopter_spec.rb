# == Schema Information
#
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string
#  email               :string
#  phone               :string
#  address1            :string
#  address2            :string
#  city                :string
#  state               :string
#  zip                 :string
#  status              :string
#  when_to_call        :string
#  created_at          :datetime
#  updated_at          :datetime
#  dog_or_cat          :string
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string
#  other_phone         :string
#  assigned_to_user_id :integer
#  flag                :string
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#  county              :string
#  training_email_sent :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe Adopter do
  let(:admin) { create(:user, :admin) }
  let(:adopter) { create(:adopter) }

  before do
    allow(Adopter).to receive(:chimp_check).and_return(true)
    allow(Adopter).to receive(:chimp_subscribe).and_return(true)
    allow(User).to receive(:chimp_check).and_return(true)
    allow(User).to receive(:chimp_subscribe).and_return(true)

    adopter.updated_by_admin_user = admin
    adopter.status = 'completed'
  end

  describe '.populate_county' do
    context 'zip changed' do
      before do
        adopter.zip = '12345'
      end

      it 'calls county service' do
        expect(CountyService).to receive(:fetch) { '12345' }

        adopter.save
      end
    end

    context 'zip did not change' do
      it 'does not call CountyService' do
        expect(CountyService).not_to receive(:fetch)

        adopter.save
      end
    end
  end
end
