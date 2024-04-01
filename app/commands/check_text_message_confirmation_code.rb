class CheckTextMessageConfirmationCode
  MAX_CONFIRMATION_CODE_ATTEMPTS = 5

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
      unset_confirmation_code
      set_api_token
    else
      update_confirmation_code_and_confirmation_code_attempts
    end

    is_correct_confirmation_code?
  end

  private

  def is_correct_confirmation_code?
    @is_correct_confirmation_code ||= \
      attempted_confirmation_code != "" &&
      player.confirmation_code == attempted_confirmation_code
  end

  def set_api_token
    if player.api_token.blank?
      player.update(api_token: SecureRandom.alphanumeric(32))
    end
  end

  def unset_confirmation_code
    player.update(confirmation_code: "")
  end

  def update_confirmation_code_and_confirmation_code_attempts
    if hit_max_confirmation_code_attempts?
      player.update(
        confirmation_code: "",
        confirmation_code_attempts: 0,
      )
    else
      player.update(
        confirmation_code_attempts: player.confirmation_code_attempts + 1
      )
    end
  end

  def hit_max_confirmation_code_attempts?
    player.confirmation_code_attempts === MAX_CONFIRMATION_CODE_ATTEMPTS - 2
  end
end
