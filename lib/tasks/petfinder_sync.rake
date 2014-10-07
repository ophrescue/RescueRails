namespace :petfinder_sync do

  require 'csv'
  require 'net/ftp'
  require 'open-uri'
  require 'fileutils'

  desc "Export Petfinder Records to CSV and Top 3 Photos"
  task export_records: :environment do
    path = "/tmp/petfinder/"
    filename = 'VA600.csv'

    FileUtils::Verbose.rm_r(path) if Dir.exists?(path)
    FileUtils::Verbose.mkdir(path)

    dogs = Dog.where({ status: ["adoptable", "adoption pending", "on hold", "return pending", "coming soon"]})
    CSV.open(path + filename, "wt", force_quotes: "true", col_sep: ",") do |csv|

      dogs.each do |d|
        csv << [d.id.to_s, 
                d.tracking_id.to_s,
                d.name,
                d.primary_breed ? d.primary_breed.name : "",
                d.secondary_breed ? d.secondary_breed.name : "",
                d.gender,
                d.size,
                d.age,
                d.description.gsub("\n", "&#10"),
                "Dog",
                d.to_petfinder_status,
                "",                              #Shots
                d.is_altered ? "1" : "",         #Altered
                d.no_dogs ? "1" : "",            #NoDogs
                d.no_cats ? "1" : "",            #NoCats
                d.no_kids ? "1" : "",            #NoKids
                "",                              #Housetrained
                "",                              #Declawed
                d.is_special_needs ? "1" : "",   #specialNeeds
                "",                              #Mix
                d.photos.count >= 1 ? d.id.to_s + "-1.jpg" : "", #Photo1 filename
                d.photos.count >= 2 ? d.id.to_s + "-2.jpg" : "", #Photo2 filename
                d.photos.count >= 3 ? d.id.to_s + "-3.jpg" : ""  #Photo3 filename
                ]
          ## Photo Export Code
          counter = 0
          d.photos.sort!{|a,b| b.updated_at <=> a.updated_at }
          d.photos[0..2].each do |p|
            counter += 1
            begin 
              open(p.photo.url(:large)).read
            rescue OpenURI::HTTPError => error
                puts "Photo not found"
            else 
                open(path + d.id.to_s + "-" + counter.to_s + ".jpg", "wb") do |file|
                   file << open(p.photo.url(:large)).read
                 end
            end
          end
      end
    end
  end

  desc "FTP Upload to Petfinder"
  task upload_files: :environment do
  end

end
