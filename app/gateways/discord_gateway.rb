class DiscordGateway
    def self.send(payload)
      webhook_url = ENV['DISCORD_WEBHOOK_URL']
      raise 'Missing DISCORD_WEBHOOK_URL' unless webhook_url.present?
  
      uri = URI.parse(webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri, { 'Content-Type' => 'application/json' })
      req.body = payload.to_json
      http.request(req)
    end
  end
  