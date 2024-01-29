class PlayersController < ApiController
  def index
    render json: serialized_players
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
end
