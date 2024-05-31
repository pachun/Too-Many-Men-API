class DeliverTextMessageConfirmationCode
  def self.deliver(phone_number:)
    new(phone_number).deliver
  end

  attr_reader :phone_number

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def deliver
    player.update(confirmation_code: confirmation_code)
    TwilioService.text(
      message: "Your Wolfpack App confirmation code is #{confirmation_code}",
      to: phone_number,
    )
  end

  private

  def confirmation_code
    @confirmation_code ||= ConfirmationCodeGenerator.generate
  end

  def player
    @player ||= Player.find_or_initialize_by(
      phone_number: phone_number,
    ).tap do |player|
      if player.api_token.blank?
        player.update(api_token: SecureRandom.alphanumeric(32))
      end
    end
  end
end
