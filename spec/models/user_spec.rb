# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  email                        :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  encrypted_password           :string(255)
#  salt                         :string(255)
#  admin                        :boolean          default(FALSE)
#  password_reset_token         :string(255)
#  password_reset_sent_at       :datetime
#  is_foster                    :boolean          default(FALSE)
#  phone                        :string(255)
#  address1                     :string(255)
#  address2                     :string(255)
#  city                         :string(255)
#  state                        :string(255)
#  zip                          :string(255)
#  duties                       :string(255)
#  edit_dogs                    :boolean          default(FALSE)
#  share_info                   :text
#  edit_my_adopters             :boolean          default(FALSE)
#  edit_all_adopters            :boolean          default(FALSE)
#  locked                       :boolean          default(FALSE)
#  edit_events                  :boolean          default(FALSE)
#  other_phone                  :string(255)
#  lastlogin                    :datetime
#  lastverified                 :datetime
#  available_to_foster          :boolean          default(FALSE)
#  foster_dog_types             :text
#  complete_adopters            :boolean          default(FALSE)
#  add_dogs                     :boolean          default(FALSE)
#  ban_adopters                 :boolean          default(FALSE)
#  dl_resources                 :boolean          default(TRUE)
#  agreement_id                 :integer
#  house_type                   :string(40)
#  breed_restriction            :boolean
#  weight_restriction           :boolean
#  has_own_dogs                 :boolean
#  has_own_cats                 :boolean
#  children_under_five          :boolean
#  has_fenced_yard              :boolean
#  can_foster_puppies           :boolean
#  parvo_house                  :boolean
#  admin_comment                :text
#  is_photographer              :boolean          default(FALSE)
#  writes_newsletter            :boolean          default(FALSE)
#  is_transporter               :boolean          default(FALSE)
#  mentor_id                    :integer
#  latitude                     :float
#  longitude                    :float
#  dl_locked_resources          :boolean          default(FALSE)
#  training_team                :boolean          default(FALSE)
#  confidentiality_agreement_id :integer
#  foster_mentor                :boolean          default(FALSE)
#  public_relations             :boolean          default(FALSE)
#  fundraising                  :boolean          default(FALSE)
#  translator                   :boolean          default(FALSE), not null
#  known_languages              :string(255)
#  code_of_conduct_agreement_id :integer
#

require 'rails_helper'

describe User do
  before do
    allow(User).to receive(:chimp_check).and_return(true)
    allow(User).to receive(:chimp_subscribe).and_return(true)
  end


  describe 'contact information' do

    context 'with valid fields' do
      it 'should accept a two letter state' do
        user = build(:user, state: 'PA')
        expect(user).to be_valid
      end
      it 'should accet a 5 digit zipcode' do
        user = build(:user, zip: '12345')
        expect(user).to be_valid
      end
      it 'should save a state abbreviation in all caps' do
        user = create(:user, state: 'pa')
        expect(user.state).to eq('PA')
      end
    end

    context 'with invalid fields' do
      it 'is invalid with a state more than 2 letters' do
        user = build(:user, state: 'Penn')
        user.valid?
        expect(user.errors[:state]).to include('is the wrong length (should be 2 characters)')
      end
      it 'is invalid with a zip code of more than 5 characters' do
        user = build(:user, zip: 'virgina')
        user.valid?
        expect(user.errors[:zip]).to include('should be 12345 or 12345-1234')
      end
    end
  end


  describe '#out_of_date?' do

    context 'user has no last_verified date' do
      let(:user) { create(:user, lastverified: nil) }

      it 'returns true' do
        expect(user.out_of_date?).to eq(true)
      end
    end

    context 'user was last_verified over 30 days ago' do
      let(:user) { create(:user, lastverified: 31.days.ago) }

      it 'returns true' do
        expect(user.out_of_date?).to eq(true)
      end
    end

    context 'user has last_verified of today' do
      let(:user) { create(:user, lastverified: Time.zone.now) }

      it 'returns false' do
        expect(user.out_of_date?).to eq(false)
      end
    end
  end
end
