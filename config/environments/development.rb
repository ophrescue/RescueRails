Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

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

  # Action Mailer Configuration
  config.action_mailer.default_url_options = { host: "rescuerails.dev", protocol: "http://" }

  # Paperclip Configuration
  Paperclip.options[:command_path] = "/usr/local/bin/"

  # Exception Notification
  ExceptionNotifier::Rake.configure

  config.middleware.use ExceptionNotification::Rack,
    email: {
      sender_address: 'info@ophrescue.org',
      exception_recipients: 'admin@ophrescue.org'
    }

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
