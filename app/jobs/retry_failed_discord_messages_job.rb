class RetryFailedDiscordMessagesJob < ApplicationJob
    queue_as :low_priority
  
    def perform
      keys = Rails.cache.read("failed_discord_msg_index") || []
  
      keys.each do |key|
        dto_hash = Rails.cache.read(key)
        next unless dto_hash
  
        begin
          dto = MessageDto.new(**dto_hash.symbolize_keys)
          DiscordNotifier.call(dto)
  
          InboxMessage.find_by(message_id: dto.message_id)&.update!(status: "sent", sent_at: Time.current)
  
          Rails.cache.delete(key)
          Rails.logger.info("✅ Retry success for #{dto.message_id}")
        rescue => e
          Rails.logger.error("⛔ Retry still failing for #{key}: #{e.message}")
        end
      end
  
      remaining = keys.select { |k| Rails.cache.exist?(k) }
      Rails.cache.write("failed_discord_msg_index", remaining)
    end
  end
  