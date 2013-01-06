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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BannedAdopter < ActiveRecord::Base

  attr_accessible :name,
  				  :phone,
  				  :email,
  				  :city,
  				  :state,
  				  :comment

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Csv.new(file.path, nil, :ignore)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.import(file)
  	CSV.foreach(file.path, headers: true) do |row|
      banned_adopter = find_by_id(row["ID"]) || new
      banned_adopter.attributes = row.to_hash.slice(*accessible_attributes)
  		banned_adopter.save!
  	end 
  end

  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      banned_adopter = find_by_id(row["id"]) || new
      banned_adopter.attributes = row.to_hash.slice(*accessible_attributes)
      banned_adopter.save!
    end
  end


end
