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

  private

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
    params.permit(:id)
  end
end
