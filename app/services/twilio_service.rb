class TwilioService
  def self.text(message:, to:)
    Twilio::REST::Client.new(
      Rails.application.credentials.twilio[:account_sid],
      Rails.application.credentials.twilio[:auth_token],
    ).messages.create(
      from: Rails.application.credentials.twilio[:phone_number],
      to: to,
      body: message,
    )
  end
end
