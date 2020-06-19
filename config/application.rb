require_relative 'boot'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'rails/all'

Bundler.require(*Rails.groups)

module Journeyctrl
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # rely on routes file for error messages
    config.exceptions_app = self.routes

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end

    # sidekiq for active_job
    config.active_job.queue_adapter = :sidekiq

    # session storage - view also => /config/initializers/session_store.rb
  end
end
