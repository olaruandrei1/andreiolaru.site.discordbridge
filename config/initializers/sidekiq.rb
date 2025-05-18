require 'sidekiq'
require 'sidekiq-scheduler'

scheduler_path = Rails.root.join("config/sidekiq.yml") 

if File.exist?(scheduler_path)
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      schedule = YAML.load_file(scheduler_path)[:schedule]
      if schedule
        Sidekiq.schedule = schedule
        Sidekiq::Scheduler.reload_schedule!
        Rails.logger.info("Sidekiq schedule loaded from sidekiq.yml")
      else
        Rails.logger.warn("No :schedule key found in sidekiq.yml")
      end
    end
  end
else
  Rails.logger.warn("sidekiq.yml not found at #{scheduler_path}")
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end
