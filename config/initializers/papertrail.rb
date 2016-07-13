Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_permissions] = 'private'
Paperclip::Attachment.default_options[:s3_credentials] = {
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  bucket: ENV['S3_BUCKET_NAME'],
  s3_region: ENV['AWS_REGION']
}
Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
