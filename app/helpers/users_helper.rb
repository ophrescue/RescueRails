#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

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
#

module UsersHelper
  def gravatar_for(user, options = { size: 50 })
    gravatar_image_tag(user.email.downcase, alt: user.name,
                                            class: 'gravatar',
                                            gravatar: options)
  end
end
