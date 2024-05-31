class CheckTextMessageConfirmationCode
  MAX_CONFIRMATION_CODE_ATTEMPTS = 3

  def self.check(phone_number:, confirmation_code:)
    new(phone_number, confirmation_code).check
  end

  attr_reader :phone_number, :confirmation_code

  def initialize(phone_number, confirmation_code)
    @phone_number = phone_number
    @confirmation_code = confirmation_code
  end

  def check
    if confirmation_code.blank? || player.blank?
      :incorrect
    elsif correct_confirmation_code?
      unset_players_confirmation_code
      :correct
    elsif maximum_number_of_incorrect_confirmation_code_attempts?
      unset_players_confirmation_code
      :incorrect_and_unset
    else
      increment_players_confirmation_code_attempts
      :incorrect
    end
  end

  private

  def player
    @player ||= Player.find_by(phone_number: phone_number)
  end

  def correct_confirmation_code?
    @correct_confirmation_code ||= player.confirmation_code == confirmation_code
  end

  def maximum_number_of_incorrect_confirmation_code_attempts?
    @maximum_number_of_incorrect_confirmation_code_attempts ||= \
      player.confirmation_code_attempts + 1 == MAX_CONFIRMATION_CODE_ATTEMPTS
  end

  def unset_players_confirmation_code(attrs = {})
    player.update(
      **attrs,
      confirmation_code: "",
      confirmation_code_attempts: 0,
    )
  end

  def increment_players_confirmation_code_attempts
    player.update(
      confirmation_code_attempts: player.confirmation_code_attempts + 1,
    )
  end
end
