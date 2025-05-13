require_relative "boot"

require "rails/all"

require_relative "../app/middleware/api_key_auth_middleware"

Bundler.require(*Rails.groups)

module AndreiolaruSiteDiscordbridge
  class Application < Rails::Application
    config.load_defaults 8.0
    config.middleware.insert_before 0, ApiKeyAuthMiddleware
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths << Rails.root.join("app/middleware")
    config.autoload_paths << Rails.root.join("app/dtos")
    config.autoload_paths << Rails.root.join("app/gateways")
    config.autoload_paths << Rails.root.join("app/services")
  end
end
