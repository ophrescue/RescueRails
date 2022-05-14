require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RescueRails
  class Application < Rails::Application
    # Needed for clearance gem overrides
    config.paths.add 'lib', eager_load: true

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :delayed_job

    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.time_zone = 'Eastern Time (US & Canada)'

    # Resolves InvalidAuthenticityToken errors in Mobile Safari and Mobile Chrome
    # https://github.com/rails/rails/issues/21948#issuecomment-163995796
    config.action_dispatch.default_headers['Cache-Control'] = 'no-store, no-cache'

    # Fixes Samesite cookie warnings
    # https://github.com/rails/rails/issues/35822
    config.action_dispatch.cookies_same_site_protection = :lax

    # after creating the dogs/ namespace to hold manager and gallery controllers, this becomes necessary
    config.action_view.prefix_partial_path_with_controller_namespace = false

    # Precompile asset file
    config.assets.precompile = ['.js', '.css', '*.css.erb', '.scss', '*.jpg', '*.png']

    # https://github.com/sass/sassc-ruby/issues/207
    config.assets.configure do |env|
      env.export_concurrent = false
    end

    # we have a custom file in support of the faker gem
    I18n.load_path += Dir[ Rails.root.join("lib","locales","**/*.yml").to_s ]

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end
