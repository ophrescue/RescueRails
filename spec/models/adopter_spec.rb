require 'spec_helper'

describe Adopter do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter) }

  before(:each) do
    Adopter.any_instance.stub(:chimp_check)
    Adopter.any_instance.stub(:chimp_subscribe)
    adopter.updated_by_admin_user = admin
    adopter.status = 'completed'
  end

  describe '#audit_changes' do
    context 'an attribute changes on an adopter' do
      it 'creates a comment' do
        expect{adopter.save}.to change{Comment.count}.by(1)
      end
    end
  end

  describe '#changes_to_sentence' do
    context 'an attribute changes' do
      it 'creates a human readable version' do
        expect(adopter.changes_to_sentence).to eq('status from new to completed')
      end
    end

    context 'many attributes have changed' do
      it 'cretes a human readable version' do
        adopter.dog_name = 'fido'
        expect(adopter.changes_to_sentence).to eq('status from new to completed\rdog_name from  to fido')
      end
    end
  end
end
