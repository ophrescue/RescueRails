namespace :petfinder_sync do
  require 'csv'
  require 'net/ftp'
  require 'open-uri'
  require 'fileutils'

  path = "/tmp/petfinder/"
  photo_path = path + "photos/"
  filename = 'VA600.csv'

  max_attempts = 5

  desc "Export Records to CSV with Top 3 Photos, upload to Petfinder"
  task export_upload: :environment do
    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Petfinder Export Start"

    FileUtils::Verbose.rm_r(path) if Dir.exists?(path)
    FileUtils::Verbose.mkdir(path)

    FileUtils::Verbose.rm_r(photo_path) if Dir.exists?(photo_path)
    FileUtils::Verbose.mkdir(photo_path)

    dog_desc_prefix = "ADOPT ME ONLINE: https://ophrescue.org/dogs/"
    cat_desc_prefix = "ADOPT ME ONLINE: https://ophrescue.org/cats/"
    desc_suffix1 = "To adopt fill out the simple online application at https://ophrescue.org &#10;"
    desc_suffix2 = "Operation Paws for Homes, Inc. (OPH) rescues dogs and cats of all breeds and ages from high-kill shelters  in NC, VA, MD, and SC, reducing the numbers being euthanized. With limited resources, the shelters are forced to put down 50-90% of the animals that come in the front door. OPH provides pet adoption services to families located in VA, DC, MD, PA and neighboring states. OPH is a 501(c)(3) organization and is 100% donor funded.  OPH does not operate a shelter or have a physical location. We rely on foster families who open their homes to give love and attention to each pet before finding a forever home."
    desc_suffix3 = "All adult dogs, cats, and kittens are altered prior to adoption. Puppies too young to be altered at the time of adoption must be brought to our partner vet in Davidsonville, MD  for spay or neuter paid for by Operation Paws for Homes by 6 months of age.  Adopters may choose to have the procedure done at their own vet before 6 months of age and be reimbursed the amount that the rescue would pay our partner vet in Davidsonville.  "

    dogs = Dog.where(
      { status: ["adoptable", "adoption pending", "coming soon"],
        hidden: false }
    )
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
                dog_desc_prefix + d.id.to_s + "&#10;&#10;" + d.description.gsub(/\r\n?/, "&#10;") + "&#10;" + desc_suffix1 + desc_suffix2 + desc_suffix3,
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
                d.photos.visible[0] ? d.photos.visible[0].photo.url(:large) : "", # url to S3 image
                d.photos.visible[1] ? d.photos.visible[0].photo.url(:large) : "",
                d.photos.visible[2] ? d.photos.visible[0].photo.url(:large) : "",
                d.photos.visible[3] ? d.photos.visible[0].photo.url(:large) : "",
                d.photos.visible[4] ? d.photos.visible[0].photo.url(:large) : "",
                d.photos.visible[5] ? d.photos.visible[0].photo.url(:large) : "",
                "", # arrival_date
                "", # birth_date
                "", # primaryColor
                "", # secondaryColor
                "", # tertiaryColor
                "", # coat_length
                "", # adoption_fee
                "", # display_adoption_fee
                "", # adoption_fee_waived
                "", # special_needs_notes
                "", # no_other
                "", # no_other_note
                ""] # tags

        ## Photo Export Code
        # next if d.photos.visible.empty?

        # counter = 0
        # d.photos.visible.order('position asc')
        # d.photos.visible[0..2].each do |p|
        #   counter += 1
        #   attempt_count = 0
        #   begin
        #     attempt_count += 1
        #     open(p.photo.url(:large)).read
        #   rescue OpenURI::HTTPError => error
        #     puts "Photo not found for dog " + d.id.to_s
        #   rescue SocketError, Net::ReadTimeout => e
        #     puts "error: #{e}"
        #     sleep 3
        #     retry if attempt_count < max_attempts
        #   else
        #     open(photo_path + d.id.to_s + "-" + counter.to_s + ".jpg", "wb") do |file|
        #       file << open(p.photo.url(:large)).read
        #     end
        #   end
        # end
      end
    end

    cats = Cat.where(
      { status: ["adoptable", "adoption pending", "coming soon"],
        hidden: false }
    )
    # at is for appending the file https://stackoverflow.com/a/23051095/6608616
    CSV.open(path + filename, "at", force_quotes: "true", col_sep: ",") do |csv|
      cats.each do |c|
        csv << ["cat" + c.id.to_s,
                c.tracking_id.to_s,
                c.name,
                c.primary_breed ? c.primary_breed.name : "",
                c.secondary_breed ? c.secondary_breed.name : "",
                c.to_petfinder_gender,
                c.to_petfinder_size,
                c.age.titleize,
                cat_desc_prefix + c.id.to_s + "&#10;&#10;" + c.description.gsub(/\r\n?/, "&#10;") + "&#10;" + desc_suffix1 + desc_suffix2 + desc_suffix3,
                "Cat",
                c.to_petfinder_status,
                "",                              # Shots
                c.is_altered ? "1" : "",         # Altered
                c.no_dogs ? "1" : "",            # NoDogs
                c.no_cats ? "1" : "",            # NoCats
                c.no_kids ? "1" : "",            # NoKids
                "",                              # Housetrained
                c.declawed ? "1" : "",           # Declawed
                c.is_special_needs ? "1" : "",   # specialNeeds
                "",                              # Mix
                c.photos.visible[0] ? c.photos.visible[0].photo.url(:large) : "", # url to S3 image
                c.photos.visible[1] ? c.photos.visible[0].photo.url(:large) : "",
                c.photos.visible[2] ? c.photos.visible[0].photo.url(:large) : "",
                c.photos.visible[3] ? c.photos.visible[0].photo.url(:large) : "",
                c.photos.visible[4] ? c.photos.visible[0].photo.url(:large) : "",
                c.photos.visible[5] ? c.photos.visible[0].photo.url(:large) : "",
                "", # arrival_date
                "", # birth_date
                "", # primaryColor
                "", # secondaryColor
                "", # tertiaryColor
                "", # coat_length
                "", # adoption_fee
                "", # display_adoption_fee
                "", # adoption_fee_waived
                "", # special_needs_notes
                "", # no_other
                "", # no_other_note
                ""] # tags

        ## Photo Export Code
        # next if c.photos.visible.empty?

        # counter = 0
        # c.photos.visible.order('position asc')
        # c.photos.visible[0..2].each do |p|
        #   counter += 1
        #   attempt_count = 0
        #   begin
        #     attempt_count += 1
        #     open(p.photo.url(:large)).read
        #   rescue OpenURI::HTTPError => error
        #     puts "Photo not found for cat " + c.id.to_s
        #   rescue SocketError, Net::ReadTimeout => e
        #     puts "error: #{e}"
        #     sleep 3
        #     retry if attempt_count < max_attempts
        #   else
        #     open(photo_path + "cat" + c.id.to_s + "-" + counter.to_s + ".jpg", "wb") do |file|
        #       file << open(p.photo.url(:large)).read
        #     end
        #   end
        # end
      end
    end

    puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Petfinder Export Completed"

    # if Rails.env.production?
    #   puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Begin Upload"
    #   ## Being Upload
    #   ftp = Net::FTP.new
    #   ftp.connect('members.petfinder.com', 21)
    #   ftp.login(ENV['PETFINDER_FTP_USER'], ENV['PETFINDER_FTP_PW'])
    #   ftp.chdir('/import/')
    #   ftp.putbinaryfile(path + filename, filename)

    #   ftp.chdir('/import/photos/')

    #   Dir.foreach(photo_path) do |file|
    #     next if file == '.' or file == '..'
    #     ftp.putbinaryfile(photo_path + file, file)
    #   end

    #   ftp.close
    #   puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Upload Completed"
    # else
    #   puts "Not production, skipping upload"
    # end
  end
end
