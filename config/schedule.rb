every 30.minutes do
    runner "RetryFailedDiscordMessagesJob.perform_later"
end
  