class PlayersController < ApiController
  def index
    render json: serialized_players
  end

  def show
    render json: serialized_player
  end

  def send_text_message_confirmation_code
    DeliverTextMessageConfirmationCode.deliver(player_id: strong_params[:id])
  end

  def check_text_message_confirmation_code
    if is_correct_text_message_confirmation_code?
      render json: { "status" => "correct", "api_token" => player.api_token }
    else
      render json: { "status" => "incorrect" }
    end
  end

  private

  def is_correct_text_message_confirmation_code?
    @is_correct_text_message_confirmation_code ||= \
      CheckTextMessageConfirmationCode.check?(
        player: player,
        attempted_confirmation_code: strong_params[:confirmation_code],
      )
  end

  def players
    @players ||= Player.all
  end

  def serialized_players
    @serialized_players ||= players.map do |player|
      PlayerSerializer.serialize(player)
    end
  end

  def player
    @player ||= Player.find(strong_params[:id])
  end

  def serialized_player
    @serialized_player ||= PlayerSerializer.serialize(player)
  end

  def strong_params
    params.permit(:id, :confirmation_code)
  end
end
