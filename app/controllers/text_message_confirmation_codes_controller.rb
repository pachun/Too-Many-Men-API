class TextMessageConfirmationCodesController < ApiController
  DUMMY_PHONE_NUMBER_FOR_IOS_APP_TESTERS_AT_APPLE = "0000000000"
  DUMMY_CONFIRMATION_CODE_FOR_IOS_APP_TESTERS_AT_APPLE = "000000"

  def deliver
    if user_is_an_ios_app_tester_at_Apple?
      set_dummy_ios_app_tester_account_confirmation_code
    else
      DeliverTextMessageConfirmationCode.deliver(
        phone_number: strong_params[:phone_number],
      )
    end
  end

  def check
    render json: check_confirmation_code_response
  end

  private

  def user_is_an_ios_app_tester_at_Apple?
    @user_is_an_ios_app_tester_at_Apple ||= \
      strong_params[:phone_number] == \
      DUMMY_PHONE_NUMBER_FOR_IOS_APP_TESTERS_AT_APPLE
  end

  def set_dummy_ios_app_tester_account_confirmation_code
    Player.find_by(
      phone_number: DUMMY_PHONE_NUMBER_FOR_IOS_APP_TESTERS_AT_APPLE,
    ).update(
      confirmation_code: DUMMY_CONFIRMATION_CODE_FOR_IOS_APP_TESTERS_AT_APPLE,
    )
  end

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
