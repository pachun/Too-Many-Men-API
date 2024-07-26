class TeamPlayersController < ApiController
  before_action :authenticate_player

  def index
    render json: serialized_players
  end

  def show
    render json: serialized_player
  end

  private

  def team
    @team ||= current_player.teams.find(strong_params[:team_id])
  end

  def players
    @players ||= team.players
  end

  def serialized_players
    @serialized_players ||= players.map do |player|
      PlayerSerializer.serialize(player)
    end
  end

  def player
    @player ||= players.find(strong_params[:id])
  end

  def serialized_player
    @serialized_player ||= PlayerSerializer.serialize(player)
  end

  def strong_params
    params.permit(:id, :team_id)
  end
end
