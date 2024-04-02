class GamesController < ApiController
  def index
    render json: serialized_games
  end

  private

  def games
    @games ||= Game.all.includes(:player_attendances, :players)
  end

  def serialized_games
    @serialized_games ||= games.map do |game|
      GameSerializer.serialize(game)
    end
  end
end
