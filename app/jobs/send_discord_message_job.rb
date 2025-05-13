class SendDiscordMessageJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 3, wait: 10.seconds

  def perform(dto_hash)
    dto = MessageDto.new(**dto_hash.symbolize_keys)

    DiscordNotifier.call(dto)

    InboxMessage.find_by!(message_id: dto.message_id)
                .update!(status: "sent", sent_at: Time.current)
  end

  rescue_from(StandardError) do |exception|
    msg_id = dto_hash["message_id"]
    cache_key = "failed_discord_msg_#{msg_id}"

    Rails.cache.write(cache_key, dto_hash, expires_in: 12.hours)
    Rails.cache.fetch("failed_discord_msg_index") { [] } << cache_key rescue nil

    InboxMessage.find_by(message_id: msg_id)&.update!(status: "failed")

    Rails.logger.error("Message #{msg_id} cached for retry: #{exception.message}")
  end
end
