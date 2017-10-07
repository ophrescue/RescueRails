namespace :petfinder_sync do
  require 'csv'
  require 'net/ftp'
  require 'open-uri'
  require 'fileutils'

  path = "/tmp/petfinder/"
  photo_path = path + "photos/"
  filename = 'VA600.csv'

  desc "Export Records to CSV with Top 3 Photos, upload to Petfinder"
  task export_upload: :environment do
    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Petfinder Export Start"

    FileUtils::Verbose.rm_r(path) if Dir.exists?(path)
    FileUtils::Verbose.mkdir(path)

    FileUtils::Verbose.rm_r(photo_path) if Dir.exists?(photo_path)
    FileUtils::Verbose.mkdir(photo_path)

    desc_prefix = "ADOPT ME ONLINE: https://ophrescue.org/dogs/"
    desc_suffix1 = "To adopt this dog, or any OPH dog, fill out the simple online application at https://ophrescue.org &#10;"
    desc_siffix2 = "Operation Paws for Homes, Inc. (OPH) rescues dogs of all breeds and ages from high-kill shelters  in NC, VA, MD, and SC, reducing the numbers being euthanized. With limited resources, the shelters are forced to put down 50-90% of the animals that come in the front door. OPH provides pet adoption services to families located in VA, DC, MD, PA and neighboring states. OPH is a 501(c)(3) organization and is 100% donor funded.  OPH does not operate a shelter or have a physical location. We rely on foster families who open their homes to give love and attention to each dog before finding a forever home."

    dogs = Dog.where({ status: ["adoptable", "adoption pending", "coming soon"]})
    CSV.open(path + filename, "wt", force_quotes: "true", col_sep: ",") do |csv|
      dogs.each do |d|
        csv << [d.id.to_s,
                d.tracking_id.to_s,
                d.name,
                d.primary_breed ? d.primary_breed.name : "",
                d.secondary_breed ? d.secondary_breed.name : "",
                d.to_petfinder_gender,
                d.to_petfinder_size,
                d.age.titleize,
                desc_prefix + d.id.to_s + "&#10;&#10;" + d.description.gsub(/\r\n?/, "&#10;") + "&#10;" + desc_suffix1 + desc_siffix2,
                "Dog",
                d.to_petfinder_status,
                "",                              # Shots
                d.is_altered ? "1" : "",         # Altered
                d.no_dogs ? "1" : "",            # NoDogs
                d.no_cats ? "1" : "",            # NoCats
                d.no_kids ? "1" : "",            # NoKids
                "",                              # Housetrained
                "",                              # Declawed
                d.is_special_needs ? "1" : "",   # specialNeeds
                "",                              # Mix
                d.photos.visible.count >= 1 ? d.id.to_s + "-1.jpg" : "", # Photo1 filename
                d.photos.visible.count >= 2 ? d.id.to_s + "-2.jpg" : "", # Photo2 filename
                d.photos.visible.count >= 3 ? d.id.to_s + "-3.jpg" : ""  # Photo3 filename
                ]

          ## Photo Export Code
          next if d.photos.visible.empty?

          counter = 0
          d.photos.visible.order('updated_at desc')
          d.photos.visible[0..2].each do |p|
            counter += 1
            begin
              open(p.photo.url(:large)).read
            rescue OpenURI::HTTPError => error
                puts "Photo not found for dog " + d.id.to_s
            else
                open(photo_path + d.id.to_s + "-" + counter.to_s + ".jpg", "wb") do |file|
                   file << open(p.photo.url(:large)).read
                 end
            end
          end
      end
    end

    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Petfinder Export Completed"

    if Rails.env.production?
      puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Begin Upload"
      ## Being Upload
      ftp = Net::FTP.new
      ftp.connect('members.petfinder.com', 21)
      ftp.login(ENV['PETFINDER_FTP_USER'], ENV['PETFINDER_FTP_PW'])
      ftp.chdir('/import/')
      ftp.putbinaryfile(path + filename, filename)

      ftp.chdir('/import/photos/')

      Dir.foreach(photo_path) do |file|
        next if file == '.' or file == '..'
        ftp.putbinaryfile(photo_path + file, file)
      end

      ftp.close
      puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Upload Completed"
    else
      puts "Not production, skipping upload"
    end
  end
end
