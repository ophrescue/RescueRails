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

require 'rails_helper'

describe Adopter do
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

  describe '.audit_changes' do
    context 'an attribute changes on an adopter' do
      it 'creates a comment' do
        expect { adopter.save }.to change { Comment.count }.by(1)
      end
    end

    context 'no admin assigned to adopter' do
      it 'does not make a comment' do
        adopter.updated_by_admin_user = nil
        expect { adopter.save }.to_not change { Comment.count }
      end
    end
  end

  describe '.changes_to_sentence' do
    context 'an attribute changes' do
      it 'creates a human readable version' do
        expect(adopter.changes_to_sentence).to eq('changed status from new to completed')
      end
    end

    context 'many attributes have changed' do
      it 'cretes a human readable version' do
        old_zip = adopter.zip
        adopter.zip = old_zip + '-1'
        expect(adopter.changes_to_sentence).to eq("changed status from new to completed * changed zip from #{old_zip} to #{old_zip}-1")
      end
    end
  end
end
