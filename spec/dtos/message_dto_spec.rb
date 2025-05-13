require 'rails_helper'

RSpec.describe MessageDto do
  let(:from)          { "user@example.com" }
  let(:email_subject) { "Test Subject" }
  let(:message)       { "This is the message body." }

  let(:dto) { described_class.new(from: from, subject: email_subject, message: message) }

  it "generates a UUID as message_id" do
    expect(dto.message_id).to be_a(String)
    expect(dto.message_id.length).to be >= 32
  end

  it "returns the correct payload format" do
    payload = dto.to_payload
    expect(payload).to be_a(Hash)
    expect(payload[:content]).to include("**From:** #{from}")
    expect(payload[:content]).to include("**Subject:** #{email_subject}")
    expect(payload[:content]).to include("**Message:** #{message}")
    expect(payload[:content]).to include("Message ID:")
  end
end
