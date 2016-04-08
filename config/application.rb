require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WedikoSecretSnowman
  class Application < Rails::Application
    # Enable the asset pipeline
    config.assets.enabled = true

    # [Steve] REMOVE THIS ONCE MAILER SET UP

    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default_url_options = { host: 'wediko.steve-pletcher.com' }


    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.initialize_on_precompile = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += Dir["#{config.root}/models/**/"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.eager_load_paths += Dir["#{config.root}/lib/**/"]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.slack_deploy_webhook_url = "https://hooks.slack.com/services/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"
    config.slack_channel = "#robots"
    config.slack_send_messages = true
  end
end
