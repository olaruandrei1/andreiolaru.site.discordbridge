class MessageDto
  attr_reader :from, :subject, :message, :message_id

  def initialize(from:, subject:, message:, message_id:)
    @from = from
    @subject = subject
    @message = message
    @message_id = message_id
  end

  def to_payload
    {
      content: <<~MSG
        **New Message Received**

        **From:** #{@from}
        **Subject:** #{@subject}
        **Message:** #{@message}

        🆔 Message ID: `#{@message_id}`
      MSG
    }
  end

  def to_h
    {
      from: @from,
      subject: @subject,
      message: @message,
      message_id: @message_id
    }
  end
end
