# One-time export of every dog's and cat's photos and attachments from S3,
# laid out as one flat folder per animal, for archiving to a Google Drive
# Shared Drive as part of decommissioning.
#
#   EXPORT_DIR/
#     manifest.csv                  one row per file (S3 key -> destination)
#     manifest_skipped.csv          DB rows with no file recorded
#     download_failures.csv         rows that failed in the last download run
#     files/
#       Dogs/1234 - Rex/photo-001-IMG_5521.jpg
#       Dogs/1234 - Rex/Foster Agreement.pdf
#       Cats/88 - Mittens/...
#
# Run on the production server, inside tmux:
#
#   RAILS_ENV=production EXPORT_DIR=/mnt/export bin/rails animal_archive:manifest
#   RAILS_ENV=production EXPORT_DIR=/mnt/export THREADS=8 bin/rails animal_archive:download
#
# Both tasks are safe to interrupt and re-run: `manifest` is read-only against
# the DB and rewrites the CSV, `download` skips files already on disk and
# retries everything else. `download` exits non-zero if any file failed.
#
# Destination names are deterministic for a given DB state, but photo numbering
# shifts if staff add/remove/reorder photos in between. If `manifest` is re-run
# after `download` has started, delete EXPORT_DIR/files first so no file is
# skipped under a name that now maps to a different S3 object.
#
# Then upload with rclone (see the remote setup in the PR description):
#
#   rclone copy /mnt/export/files oph-archive: --transfers 8 --checkers 16 \
#     --tpslimit 8 --drive-chunk-size 64M --exclude '*.part' --progress \
#     --log-file /mnt/export/rclone.log
#   rclone copy /mnt/export/manifest.csv oph-archive:
#   rclone size oph-archive:

module AnimalArchive
  SPECIES = { 'Dog' => 'Dogs', 'Cat' => 'Cats' }.freeze

  MANIFEST_HEADERS = %w[s3_key dest_path kind record_id animal_type animal_db_id
                        tracking_id animal_name original_filename content_type
                        file_size uploaded_at private description uploaded_by].freeze

  # ext4 and most filesystems cap a single name at 255 *bytes*; stay well under
  # it to leave room for the "photo-001-" prefix, " (2)" and ".part" suffixes.
  MAX_NAME_BYTES = 200

  module_function

  def export_dir
    Pathname(ENV.fetch('EXPORT_DIR', '/mnt/export'))
  end

  # Drive accepts nearly anything, but the tree also has to survive a local
  # filesystem and later downloads to Windows/macOS.
  def clean(name)
    name.to_s.dup.force_encoding(Encoding::UTF_8).scrub('_').unicode_normalize(:nfc)
        .gsub(%r{[/\\:*?"<>|\x00-\x1f]}, '_')
        .squish
        .sub(/[. ]+\z/, '')
        .presence
  end

  # Truncates by bytes (not characters) without splitting a multibyte
  # character, keeping a plausible extension.
  def truncate_bytes(name, max = MAX_NAME_BYTES)
    return name if name.bytesize <= max

    ext = File.extname(name)
    ext = '' if ext.bytesize > 20
    base = name.delete_suffix(ext).byteslice(0, max - ext.bytesize).scrub('').sub(/[. ]+\z/, '')
    base + ext
  end

  def folder_name(animal)
    id = animal.tracking_id || "no-tracking-id-#{animal.id}"
    truncate_bytes("#{id} - #{clean(animal.name) || 'unnamed'}")
  end

  # Appends " (2)", " (3)", ... before the extension until the name is unused.
  def dedupe(name, used)
    candidate = name
    n = 1
    while used.include?(candidate.downcase)
      n += 1
      ext = File.extname(name)
      candidate = "#{File.basename(name, ext)} (#{n})#{ext}"
    end
    used << candidate.downcase
    candidate
  end

  # Paperclip's S3 storage strips the leading slash from the interpolated path
  # to get the object key (kt-paperclip lib/paperclip/storage/s3.rb).
  def s3_key(attachment)
    attachment.path(:original).to_s.sub(%r{\A/}, '')
  end

  # Uploads without an extension are stored under a key ending in a bare "."
  # (Paperclip's :extension interpolates to ""), so fall back to the content type.
  def filename_for(original, content_type)
    name = clean(File.basename(original.to_s)) || 'file'
    if File.extname(name).empty?
      ext = Marcel::Magic.new(content_type.to_s).extensions.first
      name += ".#{ext}" if ext
    end
    truncate_bytes(name)
  end
end

namespace :animal_archive do
  require 'csv'
  require 'fileutils'

  desc 'Write EXPORT_DIR/manifest.csv mapping every dog/cat photo and attachment S3 key to its archive path'
  task manifest: :environment do
    dir = AnimalArchive.export_dir
    FileUtils.mkdir_p(dir)
    counts = Hash.new(0)

    CSV.open(dir.join('manifest_skipped.csv'), 'w') do |skipped|
      skipped << %w[kind record_id animal_type animal_db_id reason]

      CSV.open(dir.join('manifest.csv'), 'w') do |csv|
        csv << AnimalArchive::MANIFEST_HEADERS

        AnimalArchive::SPECIES.each do |type, top|
          used_folders = Set.new

          type.constantize.includes(:photos, attachments: :updated_by_user).find_each do |animal|
            folder = AnimalArchive.dedupe(AnimalArchive.folder_name(animal), used_folders)
            used_files = Set.new
            base = { 'animal_type' => type, 'animal_db_id' => animal.id,
                     'tracking_id' => animal.tracking_id, 'animal_name' => animal.name }

            # Sort in Ruby (on the preloaded records) with id as a tiebreaker so
            # names are stable across runs; NULL positions last, as in Postgres.
            photos = animal.photos.sort_by { |p| [p.position ? 0 : 1, p.position.to_i, p.id] }
            photos.each_with_index do |photo, i|
              if photo.photo_file_name.blank?
                skipped << ['photo', photo.id, type, animal.id, 'no photo_file_name']
                next
              end

              key = AnimalArchive.s3_key(photo.photo)
              name = format('photo-%03d-%s', i + 1, AnimalArchive.filename_for(photo.photo_file_name, photo.photo_content_type))
              name = AnimalArchive.dedupe(name, used_files)
              row = base.merge('s3_key' => key, 'dest_path' => "#{top}/#{folder}/#{name}",
                               'kind' => 'photo', 'record_id' => photo.id,
                               'original_filename' => photo.photo_file_name,
                               'content_type' => photo.photo_content_type,
                               'file_size' => photo.photo_file_size,
                               'uploaded_at' => photo.photo_updated_at&.iso8601,
                               'private' => photo.is_private)
              csv << row.values_at(*AnimalArchive::MANIFEST_HEADERS)
              counts["#{type} photos"] += 1
            end

            animal.attachments.sort_by(&:id).each do |att|
              if att.attachment_file_name.blank?
                skipped << ['attachment', att.id, type, animal.id, 'no attachment_file_name']
                next
              end

              key = AnimalArchive.s3_key(att.attachment)
              name = AnimalArchive.dedupe(AnimalArchive.filename_for(att.attachment_file_name, att.attachment_content_type), used_files)
              row = base.merge('s3_key' => key, 'dest_path' => "#{top}/#{folder}/#{name}",
                               'kind' => 'attachment', 'record_id' => att.id,
                               'original_filename' => att.attachment_file_name,
                               'content_type' => att.attachment_content_type,
                               'file_size' => att.attachment_file_size,
                               'uploaded_at' => att.attachment_updated_at&.iso8601,
                               'description' => att.description,
                               'uploaded_by' => att.updated_by_user&.name)
              csv << row.values_at(*AnimalArchive::MANIFEST_HEADERS)
              counts["#{type} attachments"] += 1
            end

            counts["#{type} folders"] += 1
          end
        end
      end
    end

    counts.sort.each { |k, v| puts format('%-20s %d', k, v) }
    puts "Manifest written to #{dir.join('manifest.csv')}"
  end

  desc 'Download every manifest.csv row from S3 into EXPORT_DIR/files (resumable)'
  task download: :environment do
    dir = AnimalArchive.export_dir
    files_dir = dir.join('files')
    threads = ENV.fetch('THREADS', '8').to_i

    s3 = Rails.application.config.paperclip_defaults[:s3_credentials] if Rails.application.config.respond_to?(:paperclip_defaults)
    abort 'No Paperclip S3 config found; run with RAILS_ENV=production' if s3.blank?

    client = Aws::S3::Client.new(region: ENV['AWS_REGION'],
                                 access_key_id: s3[:access_key_id],
                                 secret_access_key: s3[:secret_access_key])
    bucket = s3[:bucket]

    rows = CSV.read(dir.join('manifest.csv'), headers: true)
    pending = rows.reject { |r| files_dir.join(r['dest_path']).exist? }
    puts "#{rows.size} files in manifest, #{rows.size - pending.size} already downloaded, #{pending.size} to go"

    queue = Queue.new
    pending.each { |r| queue << r }
    lock = Mutex.new
    done = 0
    failures = []
    started = Time.now
    last_report = started

    workers = Array.new(threads) do
      Thread.new do
        while (row = (queue.pop(true) rescue nil))
          dest = files_dir.join(row['dest_path'])
          part = Pathname("#{dest}.part")
          begin
            FileUtils.mkdir_p(dest.dirname)
            client.get_object(bucket: bucket, key: row['s3_key'], response_target: part.to_s)
            File.rename(part, dest)
          rescue StandardError => e
            FileUtils.rm_f(part)
            lock.synchronize { failures << [row['s3_key'], row['dest_path'], row['kind'], row['record_id'], "#{e.class}: #{e.message}"] }
          end

          lock.synchronize do
            done += 1
            if Time.now - last_report >= 30
              last_report = Time.now
              rate = done / (last_report - started)
              puts format('%d/%d (%.1f files/s, ~%d min left), %d failures',
                          done, pending.size, rate, (pending.size - done) / rate / 60, failures.size)
            end
          end
        end
      end
    end
    workers.each(&:join)

    CSV.open(dir.join('download_failures.csv'), 'w') do |csv|
      csv << %w[s3_key dest_path kind record_id error]
      failures.each { |f| csv << f }
    end

    summary = "Done: #{done - failures.size} downloaded, #{failures.size} failed (see download_failures.csv)"
    abort summary if failures.any?

    puts summary
  end
end
