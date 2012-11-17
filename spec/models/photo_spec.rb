# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  dog_id             :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :timestamp(6)
#  created_at         :timestamp(6)
#  updated_at         :timestamp(6)
#  position           :integer
#

require 'spec_helper'

describe Photo do
  pending "add some examples to (or delete) #{__FILE__}"
end
