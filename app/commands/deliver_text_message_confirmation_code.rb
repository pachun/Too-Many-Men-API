class DeliverTextMessageConfirmationCode
  def self.deliver(player_id:)
    new(player_id).deliver
  end

  attr_reader :player_id

  def initialize(player_id)
    @player_id = player_id
  end

  def deliver
    set_confirmation_code
    send_confirmation_code_text_message
  end

  private

  def set_confirmation_code
    player.update(confirmation_code: confirmation_code)
  end

  def send_confirmation_code_text_message
    TwilioService.text(
      message: "Your Wolfpack App confirmation code is #{confirmation_code}",
      to: player.phone_number,
    )
  end

  def confirmation_code
    @confirmation_code ||= ConfirmationCodeGenerator.generate
  end

  def player
    @player ||= Player.find(player_id)
  end
end
