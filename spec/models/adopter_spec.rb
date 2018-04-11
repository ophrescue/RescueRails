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
#  county              :string
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
