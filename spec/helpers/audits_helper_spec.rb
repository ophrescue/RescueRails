require 'rails_helper'

RSpec.describe AuditsHelper, type: :helper do
  describe "#classify_foreign_key" do
    let(:audit_type) { Dog }

    it "returns Breed class name" do
      p = "breed_id"

      expect(helper.classify_foreign_key(p, audit_type)).to eq Breed
    end

    it "returns User class name" do
      p = "user_id"

      expect(helper.classify_foreign_key(p, audit_type)).to eq User
    end

    it "returns original value if no class is found" do
      p = "breeeeed"
      p2 = "breededed_id"

      expect(helper.classify_foreign_key(p, audit_type)).to eq p
      expect(helper.classify_foreign_key(p2, audit_type)).to eq p2
    end

    it "returns original value of there is no _id at end of string" do
      p = "patient"
      expect(helper.classify_foreign_key(p, audit_type)).to eq p
    end

    it "works for special relationships" do
      o = "primary_breed_id"

      expect(helper.classify_foreign_key(o, audit_type)).to eq Breed
    end
  end

  describe '#value_from_audit' do
    let(:user) { create(:user) }
    let(:frenchie) { create(:breed, name: 'Frenchie') }

    it 'returns Frenchie' do
      expect(helper.value_from_audit('primary_breed_id', frenchie.id, Dog)).to eq 'Frenchie'
    end

    it 'returns Female' do
      expect(helper.value_from_audit('gender', 'Female', Dog)).to eq 'Female'
    end

    it 'returns name of user' do
      expect(helper.value_from_audit('user_id', user.id, User)).to eq user.name
    end
  end
end
