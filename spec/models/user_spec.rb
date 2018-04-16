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
#  region                       :string(2)
#  postal_code                  :string(255)
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
#  boarding_buddies             :boolean          default(FALSE), not null
#  medical_behavior_permission  :boolean          default(FALSE)
#  social_media_manager         :boolean          default(FALSE), not null
#  graphic_design               :boolean          default(FALSE), not null
#  country                      :string(3)        not null
#  active                       :boolean          default(FALSE), not null
#

require 'rails_helper'

describe User do
  describe 'valid?' do
    it 'requires country' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'CA')
      expect(user).to_not be_valid

      user.country = 'USA'
      expect(user).to be_valid
    end

    it 'is invalid when country is not recognized' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'CA', country: 'ZZZ')
      expect(user).to_not be_valid
    end

    it 'is invalid when country is not supported' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'CA', country: 'ALB')
      expect(user).to_not be_valid
    end

    it 'removes whitespace from Canadian postal codes' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'ON', country: 'CAN')
      user.postal_code = "   K 2 J 0 A     1   "

      expect(user).to be_valid
      expect(user.postal_code).to eq('K2J0A1')
    end

    it 'removes whitespace from American ZIP codes' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'CA', country: 'USA')
      user.postal_code = " 12    3 4 5   "

      expect(user).to be_valid
      expect(user.postal_code).to eq('12345')
    end

    it 'converts postal codes to uppercase' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'ON', country: 'CAN')
      user.postal_code = "k2j0a1"

      expect(user).to be_valid
      expect(user.postal_code).to eq('K2J0A1')
    end

    it 'converts Canadian province to uppercase' do
      user = User.new(name: Faker::Name.name, email: 'test@example.com', region: 'on', country: 'CAN')

      expect(user).to be_valid
      expect(user.region).to eq('ON')
    end

    it 'converts American state to uppercase' do
      user = User.new(region: 'on', name: Faker::Name.name, email: 'test@example.com', country: 'USA')

      expect(user).to be_valid
      expect(user.region).to eq('ON')
    end
  end

  describe '#chimp_check' do
    before do
      allow(User).to receive(:chimp_subscribe)
      allow(User).to receive(:chimp_unsubscribe)
    end

    it 'subscribes email is changed' do
      user = create(:user, lastverified: nil)

      # Change user's email to trigger the subscription
      user.email = "new_email@test.com"

      expect(UserSubscribeJob).to receive(:perform_later)
      user.chimp_check
    end

    it 'unsubscribes when user changed to locked' do
      user = create(:user, lastverified: nil, locked: false)

      # Lock the user's account to trigger unsubscription
      user.locked = true

      expect(UserUnsubscribeJob).to receive(:perform_later)
      user.chimp_check
    end

    it 'subscribes when user is changed to unlocked' do
      user = create(:user, lastverified: nil, locked: true)

      # Unlock the user's account to trigger subscription
      user.locked = false

      expect(UserSubscribeJob).to receive(:perform_later)
      user.chimp_check
    end
  end

  before do
    allow(User).to receive(:chimp_check).and_return(true)
    allow(User).to receive(:chimp_subscribe).and_return(true)
  end

  describe 'contact information' do
    context 'with valid fields' do
      it 'should accept a two letter state' do
        user = build(:user, region: 'PA')
        expect(user).to be_valid
      end
      it 'should accept a 5 digit ZIP code' do
        user = build(:user, postal_code: '12345')
        expect(user).to be_valid
      end
      it 'should save a state abbreviation in all caps' do
        user = create(:user, region: 'pa')
        expect(user.region).to eq('PA')
      end
    end

    context 'with invalid fields' do
      it 'is invalid with a state more than 2 letters' do
        user = build(:user, region: 'Penn')
        user.valid?
        expect(user.errors[:region]).to include('State is the wrong length (should be 2 letters).')
      end
      it 'is invalid with a zip code of more than 5 characters' do
        user = build(:user, postal_code: 'virgina')
        expect(user).not_to be_valid
        expect(user.errors[:postal_code]).to include('should be 12345 or 12345-1234')
      end
      it 'is invalid when it starts with a valid zip code but contains extra characters' do
        user = build(:user, postal_code: '12345-12345')
        expect(user).not_to be_valid
        expect(user.errors[:postal_code]).to include('should be 12345 or 12345-1234')
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

  describe '#has_password' do
    let(:user) { create(:user) }

    it 'is true when password matches' do
      password = Faker::Internet.unique.password(10)
      user.update_attributes(password: password)

      expect(user.has_password?(password)).to be true
    end

    it 'is false when password does not match' do
      user.update_attributes(password: Faker::Internet.unique.password(10))

      expect(user.has_password?('not-password')).to be false
    end

    it 'is false when password is not persisted' do
      user.update_attributes(password: Faker::Internet.unique.password(10))
      new_password = 'new_password'
      user.password = new_password

      expect(user.has_password?(new_password)).to be false
    end
  end

  describe '.authenticate' do
    email = 'test@example.com'
    password = Faker::Internet.unique.password(10)

    let(:user) { create(:user) }

    it 'returns user when email and password match' do
      user.update_attributes(email: email, password: password)
      expect(User.authenticate(email, password)).to eq(user)
    end

    it 'is nil when email matches no user' do
      user.update_attributes(email: email, password: password)
      expect(User.authenticate('not-email@example.com', password)).to be nil
    end

    it 'is nil when password does not match user with email' do
      user.update_attributes(email: email, password: password)
      expect(User.authenticate(email, 'not-password')).to be nil
    end
  end

  describe '.authenticate_with_salt' do
    let(:user) { create(:user) }

    it 'returns user when salt matches' do
      expect(User.authenticate_with_salt(user.id, user.salt)).to eq(user)
    end

    it 'is nil user with id does not exist' do
      expect(User.authenticate_with_salt(999_999, user.salt)).to be nil
    end

    it 'is nil when salt does not match user with idt' do
      expect(User.authenticate_with_salt(user.id, 'not-salt')).to be nil
    end
  end

  # verifies before_save callback changed for Rails 5.1
  describe 'encrypt password' do
    it 'encrypts the password when it is present' do
      user = create(:user, :password => 'topsekret')
      expect(user.salt).not_to be_blank
      expect(user.encrypted_password).to eq Digest::SHA2.hexdigest("#{user.salt}--topsekret")
    end

    it 'saves without error when password is not present' do
      user = create(:user, :password => nil)
      expect(user.encrypted_password).to be_blank
      expect(user.salt).to be_blank
    end
  end
end
