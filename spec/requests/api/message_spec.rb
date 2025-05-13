require 'rails_helper'

RSpec.describe "Api::Messages", type: :request do
  describe "POST /api/send_message" do
    let(:valid_params) do
      {
        From: "test@example.com",
        Subject: "Test Subject",
        Message: "This is a test message."
      }
    end

    let(:headers) do
      {
        "X-Api-Key" => ENV["API_KEY"],
        "Content-Type" => "application/json"
      }
    end

    it "returns 202 Accepted with valid payload" do
      allow(SendDiscordMessageJob).to receive(:perform_later)

      post "/api/send_message", params: valid_params.to_json, headers: headers

      expect(response).to have_http_status(:accepted)
      json = JSON.parse(response.body)
      expect(json).to include("message_id", "status")
      expect(json["status"]).to eq("queued")
    end

    it "returns 400 when fields are missing" do
      post "/api/send_message", params: { From: "" }.to_json, headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to include("error")
    end
  end
end
