#-----------
# Rails Generated
#-----------

require File.expand_path('../boot', __FILE__)


require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

#------------
# My Config
#------------
require 'csv'
#------------

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module RescueRails
  class Application < Rails::Application

    #------------------
    #  Rails Generated
    #------------------

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #-----------------
    # My Configs
    #-----------------

    # Override any existing variables if an environment-specific file exists
    Dotenv.overload *Dir.glob(Rails.root.join(".env.#{Rails.env}"), File::FNM_DOTMATCH)

    config.time_zone = 'Eastern Time (US & Canada)'

    #Using Mailhopper to deliver all our mail.
    config.action_mailer.delivery_method = :mailhopper

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true

  end
end
