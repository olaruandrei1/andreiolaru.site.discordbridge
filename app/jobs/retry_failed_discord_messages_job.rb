class RetryFailedDiscordMessagesJob < ApplicationJob
  queue_as :low_priority

  def perform
    keys = Rails.cache.read("failed_discord_msg_index") || []
    new_index = []

    keys.each do |key|
      dto_hash = Rails.cache.read(key)
      unless dto_hash
        Rails.logger.warn("⚠️ Missing payload for #{key}")
        next
      end

      begin
        dto = MessageDto.new(**dto_hash.symbolize_keys)
        DiscordNotifier.call(dto)

        InboxMessage.find_by(message_id: dto.message_id)&.update!(status: "sent", sent_at: Time.current)

        Rails.cache.delete(key)
        Rails.logger.info("Retry success for #{dto.message_id}")
      rescue => e
        Rails.logger.error("Retry failed for #{dto.message_id || key}: #{e.message}")
        new_index << key unless new_index.include?(key)
      end
    end

    Rails.cache.write("failed_discord_msg_index", new_index)
  end
end
