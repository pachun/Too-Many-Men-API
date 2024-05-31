class PlayerAttendanceController < ApiController
  before_action :authenticate_player, :authenticate_players_team

  def create
    CreateOrUpdatePlayerAttendance.create_or_update(
      game_id: strong_params[:game_id].to_i,
      player_id: current_player.id,
      attending: strong_params[:attending],
    )
    head :created
  end

  private

  def team
    @team ||= Team.find(strong_params[:team_id])
  end

  def authenticate_players_team
    return head :not_found unless current_player.teams.find(team.id).present?
  end

  def strong_params
    params.permit(:game_id, :attending, :team_id)
  end
end
