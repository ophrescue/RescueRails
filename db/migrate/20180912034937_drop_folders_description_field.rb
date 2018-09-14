class DropFoldersDescriptionField < ActiveRecord::Migration[5.2]
    # include this for reference only
    NAMES_AND_DESCRIPTIONS =
      [{"name"=>"Adoption Coordination", "description"=>"Adoption Coordination Information"},
       {"name"=>"Training and Behavior Tips", "description"=>"Collection of documents to discuss training, behavior issues, and dog adjustment for new dog owners."},
       {"name"=>"Licenses and Organizations", "description"=>"Licenses, Rescue Certificates, other organizations OPH is affiliated with."},
       {"name"=>"Fundraising", "description"=>"Fundraising info and marketing materials"},
       {"name"=>"Before & After Graphics", "description"=>"Graphics"},
       {"name"=>"Adoption Contracts", "description"=>"Adoption Contracts, Spay Neuter, Addendums"},
       {"name"=>"Marketing - Graphics", "description"=>"Logos, Mastheads, OPH Advertising Graphics"},
       {"name"=>"Marketing - Brochures & General Flyers", "description"=>"OPH brochure, Foster brochure, general OPH info flyers"},
       {"name"=>"Lost Dog ", "description"=>"Lost dog info, tips, guide"},
       {"name"=>"Foster - Advertising & Brochures", "description"=>"Includes foster brochures, flyers to recruit fosters, etc."},
       {"name"=>"Merchandise", "description"=>"OPH Merchandise"},
       {"name"=>"BWW 2017", "description"=>"All documents, graphics, packets, etc. for BWW 2017"},
       {"name"=>"Contact List for OPH", "description"=>"List and documents on who to contact in OPH"}]

    NAMES_TO_CHANGE =
      [{"current_name"=>"Adoption Coordination", "new_name"=>"Adoption Coordination Information"},
       {"current_name"=>"Training and Behavior Tips", "new_name"=>"Training tips, behavior issues, and dog adjustment for new dog owners."},
       {"current_name"=>"Licenses and Organizations", "new_name"=>"Licenses, Rescue Certificates, other organizations OPH is affiliated with."},
       {"current_name"=>"Fundraising", "new_name"=>"Fundraising info and marketing materials"},
       {"current_name"=>"Before & After Graphics", "new_name"=>"Before and After Pictures"},
       {"current_name"=>"Adoption Contracts", "new_name"=>"Adoption Contracts, Spay Neuter, Addendums"},
       {"current_name"=>"Marketing - Graphics", "new_name"=>"Logos, Mastheads, OPH Advertising Graphics"},
       {"current_name"=>"Marketing - Brochures & General Flyers", "new_name"=>"OPH brochure, Foster brochure, general OPH info flyers"},
       {"current_name"=>"Lost Dog ", "new_name"=>"Lost dog info, tips, guide"},
       {"current_name"=>"Foster - Advertising & Brochures", "new_name"=>"Foster brochures, flyers to recruit fosters, etc."},
       {"current_name"=>"Merchandise", "new_name"=>"OPH Merchandise"},
       {"current_name"=>"Contact List for OPH", "new_name"=>"Contact List for OPH"}]

  def up
    change_column :folders, :name, :text # so it can accept longer values

    Folder.all.select{|f| f.attachments.empty?}.each{|f| f.destroy }
    NAMES_TO_CHANGE.each do |f|
      folder = Folder.find_by(name: f["current_name"])
      folder&.update_attribute(:name, f["new_name"])
    end

    remove_column :folders, :description
  end

  def down
    add_column :folders, :description, :text

    NAMES_TO_CHANGE.each do |n|
      folder = Folder.find_by(:name => n["new_name"])
      folder&.update_attribute(:name, n["current_name"])
    end

    NAMES_AND_DESCRIPTIONS.each do |n|
      folder = Folder.find_by(:name => n["name"])
      folder&.update_attribute(:description, n["description"])
    end
  end
end
