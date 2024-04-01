class CheckTextMessageConfirmationCode
  def self.check?(player:, attempted_confirmation_code:)
    new(player, attempted_confirmation_code).check?
  end

  attr_reader :player, :attempted_confirmation_code

  def initialize(player, attempted_confirmation_code)
    @player = player
    @attempted_confirmation_code = attempted_confirmation_code
  end

  def check?
    if is_correct_confirmation_code?
      set_api_token
    end

    is_correct_confirmation_code?
  end

  private

  def is_correct_confirmation_code?
    player.confirmation_code == attempted_confirmation_code
  end

  def set_api_token
    if player.api_token.blank?
      player.update(api_token: SecureRandom.alphanumeric(32))
    end
  end
end
