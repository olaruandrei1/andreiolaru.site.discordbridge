require 'securerandom'
require 'net/http'
require 'uri'
require 'json'
require Rails.root.join("app/dtos/message_dto")


module Api
    class MessagesController < ApplicationController
      def create
        from = params[:From]
        subject = params[:Subject]
        message = params[:Message]
      
        return render json: { error: "Missing fields" }, status: :bad_request if from.blank? || subject.blank? || message.blank?
      
        message_id = SecureRandom.uuid

        InboxMessage.create!(
          from: from,
          subject: subject,
          message: message,
          message_id: message_id,
          status: "queued"
        )
        
        SendDiscordMessageJob.perform_later(
          from: from,
          subject: subject,
          message: message,
          message_id: message_id
        )
        
        render json: { message_id: message_id, status: "queued" }, status: :accepted
      end
    end
  end
  
  