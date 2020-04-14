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
# Table name: banned_adopters
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  phone      :string(20)
#  email      :string(100)
#  city       :string(100)
#  state      :string(2)
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#

class BannedAdopter < ApplicationRecord
  # def self.open_spreadsheet(file)
  #   case File.extname(file.original_filename)
  #   when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
  #   when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
  #   when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
  #   else raise "Unknown file type: #{file.original_filename}"
  #   end
  # end

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     banned_adopter = find_by_id(row["ID"]) || new
  #     banned_adopter.attributes = row.to_hash.slice(*accessible_attributes)
  #     banned_adopter.save!
  #   end
  # end

  # def self.import(file)
  #   spreadsheet = open_spreadsheet(file)
  #   header = spreadsheet.row(1)
  #   (2..spreadsheet.last_row).each do |i|
  #     row = Hash[[header, spreadsheet.row(i)].transpose]
  #     banned_adopter = find_by_id(row["id"]) || new
  #     banned_adopter.attributes = row.to_hash.slice(*accessible_attributes)
  #     banned_adopter.save!
  #   end
  # end
end
