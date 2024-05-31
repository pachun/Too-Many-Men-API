class TextMessageConfirmationCodesController < ApiController
  def deliver
    DeliverTextMessageConfirmationCode.deliver(
      phone_number: strong_params[:phone_number],
    )
  end

  def check
    render json: check_confirmation_code_response
  end

  private

  def check_confirmation_code_response
    if confirmation_code_check_result == :correct
      correct_response
    elsif confirmation_code_check_result == :incorrect
      incorrect_response
    elsif confirmation_code_check_result == :incorrect_and_unset
      incorrect_and_unset_response
    end
  end

  def correct_response
    @correct_response ||= {
      correct_confirmation_code: true,
      api_token: player.api_token,
      player_id: player.id,
    }
  end

  def incorrect_response
    @incorrect_response ||= {
      correct_confirmation_code: false,
      confirmation_code_was_unset: false,
    }
  end

  def incorrect_and_unset_response
    @incorrect_and_unset_response ||= {
      correct_confirmation_code: false,
      confirmation_code_was_unset: true,
    }
  end

  def confirmation_code_check_result
    @confirmation_code_check_result ||= \
      CheckTextMessageConfirmationCode.check(
        phone_number: strong_params[:phone_number],
        confirmation_code: strong_params[:confirmation_code],
      )
  end

  def player
    @player ||= Player.find_by(phone_number: strong_params[:phone_number])
  end

  def strong_params
    params.permit(:phone_number, :confirmation_code)
  end
end
