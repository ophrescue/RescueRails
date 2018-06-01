namespace :rescue_rails do
  desc "move images into app/assets/images/archive if they are not referenced anywhere in views, css, javascripts"
  task :clean_images do
    archive = Rails.root.join("app","assets","images","archive")
    Dir.mkdir(archive) unless Dir.exist?(archive)
    big_string = ""
    Dir.glob(Rails.root.join("app","{controllers,helpers,jobs,mailers,models,services,validators,views,assets/javascripts,assets/stylesheets}","**","*")).each do |file|
      big_string += File.read(file) unless File.directory?(file)
    end

    image_files = Dir.glob(Rails.root.join("app", "assets", "images", "{,[!archive]**}", "*")).inject({}) do |hash,image_path|
      hash[File.basename(image_path).gsub(/\.\w*$/, '')] = image_path unless File.directory?(image_path)
      hash
    end

    archive_files = Dir.glob(Rails.root.join("app", "assets", "images", "archive", "*")).inject({}) do |hash,image_path|
      hash[File.basename(image_path).gsub(/\.\w*$/, '')] = image_path unless File.directory?(image_path)
      hash
    end

    unused_files = []
    used_files = []
    confirm_archive_files = []
    image_files.keys.each do |filename|
      if big_string.match(filename)
        used_files << image_files[filename]
      else
        unused_files << image_files[filename]
      end
    end
    puts "#{unused_files.length} unused images moved to app/assets/images/archive/"

    archive_files.keys.each do |filename|
      if big_string.match(filename)
        puts "#{filename} should not be archived"
      else
        confirm_archive_files << image_files[filename]
      end
    end

    puts "#{confirm_archive_files.length} files in archive are confirmed as unused"



    unused_files.each do |file_path|
      basename = File.basename File.new(file_path)
      #File.rename(file_path, archive.join(basename).to_s)
    end
  end
end
