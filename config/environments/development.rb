Rails.application.configure do

  # -----------
  # Rails Generated
  # ----------

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

#-----------
# My Configs
# ----------

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  config.cache_store = :dalli_store

  # Setup rack cache
  config.action_dispatch.rack_cache = {
    verbose: false,
    metastore: Dalli::Client.new,
    entitystore: 'file:tmp/cache/rack/body',
    allow_reload: false
  }

  # Do not compress assets
  config.assets.compress = false

  #Action Mailer Configuration
  config.action_mailer.default_url_options = { host: "rescuerails.dev", protocol: "http://" }

  # Paperclip Configuration
  Paperclip.options[:command_path] = "/usr/local/bin/"

  # Paperclip & Amazon S3 Configuration
  config.paperclip_defaults = {
    storage: :s3,
    s3_credentials: {
      bucket: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    s3_protocol: 'https',
    url: ':s3_domain_url'
  }

  # Exception Notification
  config.middleware.use ExceptionNotification::Rack,
    email: {
      sender_address: 'info@ophrescue.org',
      exception_recipients: 'admin@ophrescue.org'
    }

end
