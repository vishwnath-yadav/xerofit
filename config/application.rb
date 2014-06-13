require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Xerofit
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_record.schema_format = :sql

      config.action_mailer.default_url_options = { host: 'localhost:3000' }

      ADMIN_EMAIL="admin@seladex.com"

      # STRIPE_API_KEY = "sk_test_CSZ1ZaPwKkUnqoy9CRHVOaBA"
      # STRIPE_PUB_KEY = "pk_test_tPb28bRAb7DWYFpeU9l8oKhB"

      

      config.action_mailer.delivery_method = :smtp
        ActionMailer::Base.smtp_settings = {
        :address              => "smtp.gmail.com",
        :port                 => 587,
        :user_name            => 'vishuatongraph@gmail.com',
        :password             => 'vishu123',
        :authentication       => 'login',
        :enable_starttls_auto => true  }
    end
  end
