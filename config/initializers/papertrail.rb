Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_permissions] = 'private'
Paperclip::Attachment.default_options[:s3_credentials] = {
  access_key_id: 'AKIAIE6CHWJQEXJKDHPA',
  secret_access_key: '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',
  bucket: 'oph-dogs',
  s3_region: 'us-west-2'
}
Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
