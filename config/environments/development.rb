Xerofit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  FACEBOOK_KEY = "1441124259474236"
  FACEBOOK_SECRET = "93b2c340b13ed77606c4d2b5129b9381"

  APP_ID = "1044996955605-gr0lvpu3ejbf4jlc2ghh3ut3vt78h8er.apps.googleusercontent.com"
  APP_SECRET_ID = "EiJx0W5quLsbidRx-n2Y6AyE"

  TWITTER_KEY = "OfWiBajwBXc5SMdR5fDxfR6O7"
  TWITTER_SECRET = "ig8B2noq4szAMMKAuzn37ssT98bB7ZDRPZy8FeFCy0K6zSxbEz"
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

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
end
