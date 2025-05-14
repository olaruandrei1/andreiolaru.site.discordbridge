require 'sidekiq'
require 'sidekiq-scheduler'

require 'sidekiq-scheduler'

scheduler_path = Rails.root.join("config/sidekiq-scheduler.yml")

if File.exist?(scheduler_path)
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      Sidekiq.schedule = YAML.load_file(scheduler_path)
      Sidekiq::Scheduler.reload_schedule!
      Rails.logger.info("Sidekiq schedule loaded")
    end
  end
else
  Rails.logger.warn("sidekiq-scheduler.yml not found at #{scheduler_path}")
end
