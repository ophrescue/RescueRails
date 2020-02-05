namespace :adoptapet_sync do
  require 'csv'
  require 'net/ftp'
  require 'open-uri'
  require 'fileutils'

  path = "/tmp/adoptapet/"
  STATES = ['PA', 'MD', 'VA']

  desc "Export Records to CSV for adoptapet"
  task export_upload: :environment do
    if Rails.env.production?
      FileUtils::Verbose.rm_r(path) if Dir.exists?(path)
      FileUtils::Verbose.mkdir(path)
      FileUtils::Verbose.cp "#{Rails.root.to_s}/lib/tasks/import.cfg", path
    else
      FileUtils.rm_r(path) if Dir.exists?(path)
      FileUtils.mkdir(path)
      FileUtils.cp "#{Rails.root.to_s}/lib/tasks/import.cfg", path
    end

    STATES.each do |state|
      filename = "pets_#{state}.csv"

      if Rails.env.production?
        puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Adoptapet #{state} Export Start"
      end

      dogs = Dog.joins(:foster).where(
        { status: Dog::PUBLIC_STATUSES,
          users: {region: state}
         })

      desc_prefix = "ADOPT ME ONLINE: https://ophrescue.org/dogs/"

      CSV.open(path + filename, "wt", force_quotes: "true", col_sep: ",") do |csv|
        dogs.each do |d|
          photo_urls = Array.new
          pics = d.photos.visible.reorder('position asc')
          pics[0..3].each do |p|
            photo_urls << p.photo.url(:large)
          end

          csv << [d.id.to_s,
                  "Dog",
                  d.primary_breed ? d.primary_breed.name : "",
                  d.secondary_breed ? d.secondary_breed.name : "",
                  "N",                             # PureBreed
                  d.name,
                  d.age,
                  d.to_petfinder_gender,
                  d.to_petfinder_size,
                  desc_prefix + d.id.to_s + "<br>" + d.description.gsub(/\r\n?/, "<br>"),
                  "Available",                      # status
                  d.no_kids ? "N" : "",            # GoodWKids
                  d.no_cats ? "N" : "",            # GoodWCats
                  d.no_dogs ? "N" : "",            # GoodWDogs
                  d.is_altered ? "Y" : "N",         # SpayedNeutered
                  d.is_special_needs ? "Y" : "N",    # SpecialNeeds
                  photo_urls[0],
                  photo_urls[1],
                  photo_urls[2],
                  photo_urls[3],
                  d.youtube_video_url ? d.youtube_video_url : ""
          ]
        end
      end

      if Rails.env.production?
        puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Adoptapet #{state} Export Complete"
        puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Begin Upload for #{state}"
        ## Being Upload
        ftp = Net::FTP.new
        ftp.connect('autoupload.adoptapet.com', 21)
        ftp.login(ENV["ADOPTAPET_#{state}_USER"], ENV["ADOPTAPET_#{state}_PW"])
        ftp.putbinaryfile(path + filename, "pets.csv")
        ftp.putbinaryfile(path + "import.cfg", "import.cfg")

        ftp.close
        puts Time.now.strftime("%m/%d/%Y %H:%M")+ " Upload Completed for #{state}"
      end
    end
  end
end
