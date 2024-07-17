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
    if Rails.env.development?
      puts message
    else
      TwilioService.text(
        message: message,
        to: phone_number,
      )
    end
  end

  private

  def message
    @message ||= "Your Too Many Men App confirmation code is #{confirmation_code}"
  end

  def confirmation_code
    @confirmation_code ||= ConfirmationCodeGenerator.generate
  end

  def player
    @player ||= Player.find_or_initialize_by(
      phone_number: phone_number,
    ).tap do |player|
      if player.api_token.blank?
        player.api_token = SecureRandom.alphanumeric(32)
      end
      if player.first_name.nil?
        player.first_name = ""
      end
      if player.last_name.nil?
        player.last_name = ""
      end
    end
  end
end
