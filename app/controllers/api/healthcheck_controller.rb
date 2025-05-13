module Api
    class HealthcheckController < ApplicationController
      def show
        message = MessageDto.new(
          from: "healthcheck@andreiolaru.site",
          subject: "HEALTHCHECK++",
          message: "🧠 Everything's fine, boss. I'm still alive. 🤖"
        )
  
        SendDiscordMessageJob.perform_later(
          from: message.from,
          subject: message.subject,
          message: message.message
        )
  
        render json: {
          status: "ok",
          time: Time.current.iso8601,
          app: "andreiolaru.site.discordbridge"
        }, status: :ok
      end
    end
  end
  