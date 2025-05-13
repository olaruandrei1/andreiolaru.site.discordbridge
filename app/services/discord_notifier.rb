class DiscordNotifier
    def self.call(dto)
      DiscordGateway.send(dto.to_payload)
    end
  end
  