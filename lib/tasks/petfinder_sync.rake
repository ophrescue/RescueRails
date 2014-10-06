namespace :petfinder_sync do

  require 'csv'
  require 'net/ftp'

  desc "TODO Export Petfinder Records to CSV and Top 3 Photos"
  task export_records: :environment do
    path = "/tmp/"
    filename = 'VA600.csv'

    dogs = Dog.where({ status: ["adoptable", "adoption pending", "on hold", "return pending", "coming soon"]})
    CSV.open(path + filename, "wt", force_quotes: "true", col_sep: ",") do |csv|

      dogs.each do |d|
        csv << [d.id.to_s, 
                d.tracking_id.to_s,
                d.name,
                d.primary_breed_name,
                d.secondary_breed_name,
                d.gender,
                d.size,
                d.age,
                d.description,
                "Dog",
                d.to_petfinder_status,
                "",                         #Shots
                d.is_altered ? "1" : "",         #Altered
                d.no_dogs ? "1" : "",            #NoDogs
                d.no_cats ? "1" : "",            #NoCats
                d.no_kids ? "1" : "",            #NoKids
                "",                              #Housetrained
                "",                              #Declawed
                d.is_special_needs ? "1" : "",   #specialNeeds
                "",   #Mix
                "",   #Photo1
                "",   #Photo2
                ""    #Photo3
                ]
      end
    end
  end

  desc "FTP Upload to Petfinder"
  task upload_files: :environment do
  end

end
