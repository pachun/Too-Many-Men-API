class GamesController < ApiController
  before_action :authenticate_player, :authenticate_players_team

  def index
    render json: serialized_games
  end

  def show
    render json: serialized_game
  end

  private

  def game
    @game ||= Game.find(strong_params[:id])
  end

  def serialized_game
    @serialized_game ||= GameSerializer.serialize(game)
  end

  def authenticate_players_team
    return head :not_found unless current_player.teams.find(team.id).present?
  end

  def team
    @team ||= Team.find(strong_params[:team_id])
  end

  def games
    @games ||= Game.all.includes(:player_attendances, :players)
  end

  def serialized_games
    @serialized_games ||= games.map do |game|
      GameSerializer.serialize(game)
    end
  end

  def strong_params
    params.permit(:team_id, :id)
  end
end
